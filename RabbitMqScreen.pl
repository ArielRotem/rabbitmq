use LWP::Simple;

#############################################################################################
################### IMPORTANT VERIABLES ##################################################### 
 my $rabbits = 'rabbits.txt'; ## each like contains: rabbit name,rabbitmq link, [newline/NULL]
 my $outputPath = 'rabbitmqs.html';
 my $colSizePxl = 400;
 my $notokThrethold = 5000;
 my $warningThrethold = 2500;
 my $boolPlaySound = "false";
 my $mysoundTimeout = 0;
 my $header = '
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
 <html>
<head>
 <meta http-equiv="refresh" content="5" >

<title>Rabbit Mq Monitoring</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" href="css/styles.css" rel="stylesheet" media="all" />
<link href=\'http://fonts.googleapis.com/css?family=Viga\' rel=\'stylesheet\' type=\'text/css\'>
</head>

<body>
<div id="menu-holder">

<div class="price_table">
 
 ';
my $tail = '
<div class="column-clear"></div>
<div class="content">
<p>The quieter you become the more you are able to hear - Ariel©</p>
<p id="home"><a class="go" href="www.nocrulz.com" title="">Go to article page</a></p>
</div>

</div><!--end menu-holder-->

</body>
</html>';

my $preName = '<div class="column_1">
<ul>
<li class="header_row_1 align_center">
<div class="pack-title">';
my $preNameRed = '<div class="column_1">
<ul>
<li class="header_row_1 red align_center">
<div class="pack-title">';
my $preNameOrange = '<div class="column_1">
<ul>
<li class="header_row_1 orange align_center">
<div class="pack-title">';
my $nameToCount = '</div>
</li>
<li class="header_row_2 align_center">
<div class="price"><span>';
my $countToRoll = '</span></div>
<div class="time">';
my $closeRoll = '</div></li>';
my $openQueueCheck = '<li class="row_style_1 align_left "><span>';
my $openQueueUnCheck = '<li class="row_style_1 align_left no-option"><span>';
my $openQueueWhite = '<li class="row_style_1 align_left white"><span>';
my $closeQueue = '</span></li>';
my $queuesToFooter = '<li class="row_style_footer_1"><a href="#" class="buy_now">';
my $footerToCloseRabbit = '</a></li></ul></div><!--end column-->';

my $finalPage;

print "here";
$infected=0;

while(true){
$infected--;
open(my $fh, '<:encoding(UTF-8)', $rabbits)or die "Could not open file '$rabbits' $!";

$finalPage = $header . '<H3>Check Time:'.localtime().'</H3>';
while (my $row = <$fh>) {
	
	chomp $row;
	$noBreak = "";
	($name,$roll,$url,$noBreak) = split(',',$row);
	
	if($noBreak eq "break"){
		$finalPage = $finalPage . '<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>';
	}
	my $content = "";
    my $content = get $url;
	$content =~ s/node/node\n/g;
	my @lines = split /\n/, $content;
	if($content eq ""){
		$noneZeroQueues = -1;
	}else{
		$noneZeroQueues = 0;
	}
	$count = 0;
	$finalQueue = "";
	$noneZeroQueues = 0;
	foreach my $line (@lines) {
		## "len":127, ... ""pending_acks":0 ...  "name":"production_euwest_1.defferer_wait10", ## V. 3.1.5
		## "len":127, ...  ...  "name":"production_euwest_1.defferer_wait10", ## V. 3.5.1

		if($line =~ m/.*?"len":(\d+).*?("pending_acks":(\d+)).*?"name":"(.*?)",.*?/) {
			$queue = "";
			$sum12=($1+$3);
			if($sum12>$notokThrethold){
				$queue = "<B>" . $sum12 . "</B>&nbsp;" . $4 ;
				$count += $sum12;
				$queue =~ s/production_//g;
				$queue =~ s/_wait//g;
				$queue =~ s/_//g;
				$queue =~ s/nagiosmonitor/nagios monitor/g;
				$queue = $openQueueUnCheck . $queue . $closeQueue;
				$finalQueue = $finalQueue . $queue . "<BR>" ;
				print "found " . $name .":". $4 . "\n";
				$noneZeroQueues++;
			}elsif($sum12>0){
				$queue = "<B>" . $sum12 . "</B>&nbsp;" . $4 ;
				$count += $sum12;
				$queue =~ s/production_//g;
				$queue =~ s/_wait//g;
				$queue =~ s/_//g;
				$queue =~ s/nagiosmonitor/nagios monitor/g;
				$queue = $openQueueCheck . $queue . $closeQueue;
				$finalQueue = $finalQueue . $queue . "<BR>" ;
				print "found " . $name .":". $4 . "\n";
				$noneZeroQueues++;
			}else{
			}
			
				
		}elsif($line =~ m/.*?"len":(\d+).*?"name":"(.*?)",.*?/){
			$queue = "";
			$sum12=($1+$3);
			if($sum12>$notokThrethold){
				$queue = "<B>" . $sum12 . "</B>&nbsp;" . $4 ;
				$count += $sum12;
				$queue =~ s/production_//g;
				$queue =~ s/_wait//g;
				$queue =~ s/_//g;
				$queue =~ s/nagiosmonitor/nagios monitor/g;
				$queue = $openQueueUnCheck . $queue . $closeQueue;
				$finalQueue = $finalQueue . $queue . "<BR>" ;
				print "found " . $name .":". $4 . "\n";
				$noneZeroQueues++;
			}elsif($sum12>0){
				$queue = "<B>" . $sum12 . "</B>&nbsp;" . $4 ;
				$count += $sum12;
				$queue =~ s/production_//g;
				$queue =~ s/_wait//g;
				$queue =~ s/_//g;
				$queue =~ s/nagiosmonitor/nagios monitor/g;
				$queue = $openQueueCheck . $queue . $closeQueue;
				$finalQueue = $finalQueue . $queue . "<BR>" ;
				print "found " . $name .":". $4 . "\n";
				$noneZeroQueues++;
			}else{
			}
		}else{
		}
		

	}
	while ($noneZeroQueues<5 && $noneZeroQueues>-1 ){
				$finalQueue = $finalQueue . $openQueueWhite . "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" . $closeQueue . "<BR>" ;
				$noneZeroQueues++;
	}
	($authurl,$rest) = split('/api',$url);
	($junk,$url2) = split('@',$authurl);
	my $queuesToFooter = '<li class="row_style_footer_1"><a href="http://'.$url2.'" class="buy_now">';
	if($content eq ""){
	   	$finalPage = $finalPage . $preName . $name . $nameToCount . "X" . $countToRoll . $roll . $closeRoll . "<B>Rabbit Not Found</B>" . $queuesToFooter . "Error" . $footerToCloseRabbit ;
	}elsif($count>$notokThrethold){
		$finalPage = $finalPage . $preNameRed . $name . $nameToCount . $count . $countToRoll . $roll . $closeRoll . $finalQueue . $queuesToFooter . "Not ok" . $footerToCloseRabbit ;
		if($infected<0){
		$infected = 25;
		use Win32::Sound;
		Win32::Sound::Volume('100%');
		Win32::Sound::Play("bugs_whats_up_doc.wav");
		print "Sleping 5secs";
		sleep(5);
		Win32::Sound::Stop();
	}
	}elsif($count>$warningThrethold){
		$finalPage = $finalPage . $preNameOrange . $name . $nameToCount . $count . $countToRoll . $roll . $closeRoll . $finalQueue . $queuesToFooter . "warning" . $footerToCloseRabbit ;
	}else{
		$finalPage = $finalPage . $preName . $name . $nameToCount . $count . $countToRoll . $roll . $closeRoll . $finalQueue . $queuesToFooter . "ok" . $footerToCloseRabbit ;
	}
	
}
 	
 open(my $fh3, '>', $outputPath)or die "Could not open file '$outputPath' $!";
 print $fh3 "" . $finalPage . $tail ;
 close $fh;
 close $fh3;

print "Sleping 5secs";
sleep(5);
 

}

 
 
 
 
  