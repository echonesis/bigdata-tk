use strict;
use warnings;

my $input_folder = "./data/";
my $input_dynamic_file = "DynamicFile.csv";
my $input_defect_file = "DefectMap.csv";
my $input_nce_file = "NceMa.csv";
my $output_folder = "./";
my $output_result_file = "Result.csv";


# Input dynamic_item
open(FILE1, "<${input_folder}${input_dynamic_file}");
my %waffield;
my %fcenter_x;
my %fcenter_y;
my %fsize_x;
my %fsize_y;
my %fmsdz;
while(<FILE1>){
	chomp;
	my @array = split(/,/, $_);
	if ( $array[0] ne "wafer_id" ){
		my $wafer_id = $array[0];
		my $area_id = $array[1];
		my $centerx = $array[2];
		my $centery = $array[3];
		my $sizex = $array[4];
		my $sizey = $array[5];
		my $tmsdz = $array[6];
		my $target_field_name = $wafer_id . "_" . $area_id;
		if ( !exists $waffield{$wafer_id} ){
			$waffield{$wafer_id} = $target_field_name;
		} else {
			# concatenate with delimiter ,
			my @tmpArray = split(/,/, $waffield{$wafer_id});
			my %tmpCheck = map { $_ => 1 } @tmpArray;
			if ( exists $tmpCheck{$wafer_id} ){
				$waffield{$wafer_id} = $waffield{$wafer_id} . "," . $target_field_name; 
			}
		}
	
		# field position setting
		if ( !exists $fcenter_x{$target_field_name} ){
			$fcenter_x{$target_field_name} = $centerx;
		}
		if ( !exists $fcenter_y{$target_field_name} ){
			$fcenter_y{$target_field_name} = $centery;
		}
		if ( !exists $fsize_x{$target_field_name} ){
			$fsize_x{$target_field_name} = $sizex;
		}
		if ( !exists $fsize_y{$target_field_name} ){
			$fsize_y{$target_field_name} = $sizey;
		}
	
		# MSD Z Setting
		if ( !exists $fmsdz{$target_field_name} ){
			$fmsdz{$target_field_name} = $tmsdz;
			#print "$fmsdz{$target_field_name}\n";
		} else {
			$fmsdz{$target_field_name} = $fmsdz{$target_field_name} . "," . $tmsdz;
			#print "$fmsdz{$target_field_name}\n";
		}
	}
	
}
close(FILE1);

# Input defect_map
open(FILE2, "<${input_folder}${input_defect_file}");
my %defect_cnt;
while(<FILE2>){
	chomp;
	my @array = split(/,/, $_);
	my $wafer_id = $array[0];
	my $xpos = $array[1];
	my $ypos = $array[2];
	if ( $wafer_id ne "wafer_id" ){
		if ( exists $waffield{$wafer_id} ){
		#print "Debug1 $wafer_id\n";
			my @wff_selected = split(/,/, $waffield{$wafer_id});
			#print "Length: $#wff_selected\n";
			foreach my $cdd(@wff_selected){
				#print "$cdd\n";
				if ( $xpos >= $fcenter_x{$cdd} - 0.5 * $fsize_x{$cdd} && $xpos <= $fcenter_x{$cdd} + 0.5 * $fsize_x{$cdd} &&
						$ypos >= $fcenter_y{$cdd} - 0.5 * $fsize_y{$cdd} && $ypos <= $fcenter_y{$cdd} + 0.5 * $fsize_y{$cdd} ){
					if ( !exists $defect_cnt{$cdd} ){
						$defect_cnt{$cdd} = 1;
						#print "Debug2 $defect_cnt{$cdd}\n";
					} else {
						$defect_cnt{$cdd} = $defect_cnt{$cdd} + 1;
						#print "Debug3 $defect_cnt{$cdd}\n";
					}
				} else {
					print "[Process Status] Not this field...";
				}
			}
		
		} else {
		print "[Process Status] Invalid wafer-field matching table1...\n";
		print "[Process Status] Please contact your data provider...\n";
		}
	}
}
close(FILE2);

# Input nce_ma_item
open(FILE3, "<${input_folder}${input_nce_file}");
my %nce_ma_array;
while(<FILE3>){
	chomp;
	my @array = split(/,/, $_);
	my $wafer_id = $array[0];
	my $xpos = $array[1];
	my $ypos = $array[2];
	my $ncema = $array[3];
	if ( $array[0] ne "wafer_id" ){
		if ( exists $waffield{$wafer_id} ){
			my @wff_selected = split(/,/, $waffield{$wafer_id});
			foreach my $cdd(@wff_selected){
				if ( $xpos >= $fcenter_x{$cdd} - 0.5 * $fsize_x{$cdd} && $xpos <= $fcenter_x{$cdd} + 0.5 * $fsize_x{$cdd} &&
						$ypos >= $fcenter_y{$cdd} - 0.5 * $fsize_y{$cdd} && $ypos <= $fcenter_y{$cdd} + 0.5 * $fsize_y{$cdd} ){
					if ( !exists $nce_ma_array{$cdd} ){
						$nce_ma_array{$cdd} = $ncema;
						#print $nce_ma_array{$cdd};
					} else {
						$nce_ma_array{$cdd} = $nce_ma_array{$cdd} . "," . $ncema;
					}
				} else {
					#print "[Process Status] Not this field...";
				}
			}
		} else {
			print "[Process Status] Invalid wafer-field matching table...\n";
			print "[Process Status] Please contact your data provider...\n";
		}
	}
}
close(FILE3);

# Output File
open(FILE4, ">>${output_folder}${output_result_file}");
foreach my $var(values %waffield){
	#print $var;
	if ( exists $nce_ma_array{$var} && exists $defect_cnt{$var}){
		my @ma_array = split(/,/, $nce_ma_array{$var});
		my $ma_mean = do { my $s; $s += $_ for @ma_array; $s / @ma_array };
		
		my @msdz_array = split(/,/, $fmsdz{$var});
		my $msdz_max = (sort { $b <=> $a } @msdz_array)[0];
	
		print FILE4 $defect_cnt{$var} . "," . $msdz_max . "," . $ma_mean . "\n";
	}
	
}
close(FILE4);