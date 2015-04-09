use LWP::Simple;

#############################################################################################
################### IMPORTANT VERIABLES ##################################################### 
 my $rabbits = 'rabbits.txt'; ## each like contains: rabbit name,rabbitmq link, [newline/NULL]
 my $outputPath = 'rabbitmqs.html';
 my $colSizePxl = 400;
 my $header = '
<!DOCTYPE html>
<html>

<head>
 <meta charset="UTF-8">
 <meta http-equiv="refresh" content="5" >
 <title>RabbitMq Monitoring</title>
 <link rel="stylesheet" href="css/reset.css">
 <link rel="stylesheet" href="css/style.css">
</head>
<body>
 <div class="wrap">
 <div class="table">
 <ul>
';
my $tail = '
</ul>
</div>
</div>
<script src=\'http://codepen.io/assets/libs/fullpage/jquery.js\'></script>
<script src="js/index.js"></script>
</body>
</html>';
my $block1 = '<li>
  <div class="top purple white">
    <h1>';
my $block2 = '</h1>
    <div class="circle pink">';
my $block2red = '</h1>
    <div class="circle red">';
my $block3 = '</div>
  </div>
    <div class="bottom">';
my $block4 = '<div class="sign">
    <a href="" class="button purple" style="color:white;">OK</a>
    </div>
  </div>
</li>';

my $finalPage;

 
 

while(true){
open(my $fh, '<:encoding(UTF-8)', $rabbits)or die "Could not open file '$rabbits' $!";

$finalPage = $header . '<H3>Check Time:'.localtime().'</H3>';
while (my $row = <$fh>) {
	
	chomp $row;
	$noBreak = "";
	($name, $url , $noBreak) = split(',',$row);
	
	if($noBreak eq "break"){
		$finalPage = $finalPage . '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>';
	}
	my $content = "";
    my $content = get $url;
	$content =~ s/\[/\[\n/g;
	my @lines = split /\n/, $content;
	if($content eq ""){
		$finalPage = $finalPage . $block1 . $name . $block2red ;
	}else{
		$finalPage = $finalPage . $block1 . $name . $block2 ;
	}
	$count = 0;
	$finalQueue = "";
	foreach my $line (@lines) {
		## "len":127, ...  "name":"production_euwest_1.defferer_wait10", ##
		
		if($line =~ m/.*?"len":(\d+).*?"name":"(.*?)",.*?/) {
			$queue = "<B>" . $1 . "</B>&nbsp;   " . $2 ;
			$count += $1;
			if($1>0){
				$finalQueue = $finalQueue . $queue . "<BR>";
				print "found " . $name . "\n";
			}
		} else {
			##print "buga: " . $line . " \n";
			##$finalPage = $finalPage ."\n<BR><H2>".$name."<BR>NOT FOUND!<\/H2>\n<BR>";
		}
		

	}
	if($content eq ""){
	   	$finalPage = $finalPage . "X" . $block3 . "<B>Rabbit Not Found</B>" . $block4 ;
	}else{
		$finalPage = $finalPage . $count . $block3 . $finalQueue . $block4 ;
	}
	
}
 	$finalPage =~ s/production_//g;
	$finalPage =~ s/_wait//g;
	$finalPage =~ s/_//g;
	$finalPage =~ s/nagiosmonitor/nagios monitor/g;

 open(my $fh3, '>', $outputPath)or die "Could not open file '$outputPath' $!";
 print $fh3 "" . $finalPage . $tail ;
 close $fh;
 close $fh3;

print "Sleping 5secs";
 sleep(5);
 

}

 
 
 
 
  