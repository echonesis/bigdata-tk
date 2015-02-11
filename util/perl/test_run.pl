#!/usr/bin/perl -w
use strict;
use warnings;

my $input_folder = "./";
my $input_file = "testdata.csv";
my $output_folder = "./";
my $output_result_file = "Result.csv";
my $eventTimeCol = 0;
my $eventSrcAddCol = 1;
my $eventDstAddCol = 2;
my $eventTypeCol = 3;
my $type = 0;

if ($#ARGV == 1){
	$input_file = $ARGV[0];
	# $type = 0;
} elsif ($#ARGV > 1){
	$input_file = $ARGV[0];
	$type = $ARGV[1];
	# $type = 0;
} else {
	;
}

# Input dynamic_item
open(FILE1, "<${input_folder}${input_file}");
while(<FILE1>){
	chomp;
	if ($_ !~ /event.*/){
		my @array = split(/,/, $_);
		my $output_file_name = $output_folder . "/" . $array[$eventDstAddCol] . ".csv";
		open(FILE4, ">>${output_file_name}");
		
		if ($type == 0){
			print FILE4 $array[$eventSrcAddCol] . "," . $array[$eventTimeCol] . "\n";
		} else {
			if ($array[$eventTypeCol] eq $type) {
				print FILE4 $array[$eventSrcAddCol] . "," . $array[$eventTimeCol] . "\n";
			}
		}
		
		close(FILE4);
	}
	
	
}
close(FILE1);
