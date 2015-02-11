use strict;
use warnings;

my $teststr = "0,3,2,4,5,10";
my @array = split(/,/, $teststr);
foreach my $cdd(@array){
	my $mean = do { my $s; $s += $_ for @array; $s / @array };
	print "$mean\n";
}