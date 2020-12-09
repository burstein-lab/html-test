#####################################################
# Purpose: Find common records in two files
# Parameters: Two input file with protein name and length on each line
# Output: List of common protein names with identical length in both files
#####################################################

use strict;
use proteinLengths;		# Contains subrouthines for reading and comparing protein length hashes.

# Open input file
if (scalar(@ARGV) < 2) {die "USAGE: class_ex.pl INPUT_FILE1 INPUT_FILE2\n";}
my ($inFile1, $inFile2) = @ARGV;

# Read first file into hash
my $proteinLengths = proteinLengths::readProteinLengthsFile($inFile1);

# Read second file and compare to the hash of the first file
my ($line, $name, $length);
open(IN2, $inFile2) or die "Can't open file $inFile2\n";

while (defined($line = <IN2>)) {
	if ($line =~ m/^(\S+)\s+(\d+)/) {

		#get name and length and compare to hash of first file
		($name, $length) = ($1,$2);
		my $comp = proteinLengths::compareProtLength($name,$length,$proteinLengths);
		
		# print name if exist in first file with same lengh or warning if exists, but with different length
		if ($comp == 1) {
			print "$name\n";
		} elsif ($comp == 2) {
			print "$name appears with different lengths!\n";
		}
	} else { die "bad line format: '$line'"; }
}
