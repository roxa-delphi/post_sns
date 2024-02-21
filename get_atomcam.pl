#!/usr/bin/perl
use strict;

#
# save image to data/yymmdd/yymmdd_hhmmss.jpg from atomcam
# post image to bluesky with comment yymmdd_hhmm
#

my $dir = "data";
my $odir;
my $fname;
my $mess;
my @datetime;
my $yyyymmdd;
my $hhmmss;
my $hhmm;
my $mm;

@datetime = localtime(time);

$datetime[5] += 1900;
$datetime[4] ++;

$yyyymmdd = sprintf("%04d%02d%02d", $datetime[5], $datetime[4], $datetime[3]);
$hhmmss   = sprintf("%02d%02d%02d", $datetime[2], $datetime[1], $datetime[0]);
$hhmm     = sprintf("%02d%02d",     $datetime[2], $datetime[1]);
$mm       = sprintf("%02d",         $datetime[1]);
$odir     = "$dir/$yyyymmdd";
$fname    = "$odir/${yyyymmdd}_$hhmmss.jpg";

#print("yyyymmdd = $yyyymmdd\n");
#print("  hhmmss = $hhmmss\n");
print("fname = $fname\n");


if (! -d $dir) {
	mkdir $dir
}

if (! -d $odir) {
	mkdir $odir
}


# get AtomCam image
`wget http://(atomcam_ip_address):8080/cgi-bin/get_jpeg.cgi -o get_atomcam.log -O $fname`;


# post to bluesky
if ($mm eq "00") {
	$mess = "${yyyymmdd}_$hhmm";
	`atproto/bin/python3 bs_postimage.py $mess $fname`;
}

