#####################################################
# Purpose: Find common records in two files
# Parameters: Two input file with protein name and length on each line
# Output: List of common protein names with identical length in both files
#####################################################

use strict;

if (scalar(@ARGV) < 2) {die "USAGE: $0 INPUT_FILE1 INPUT_FILE2\n";}
my ($inFile1, $inFile2) = @ARGV;
my ($line, $name, $length, %proteinLengths);

# Read first file and store the data in a hash
open(IN1, "<$inFile1") or die "Can't open file '$inFile1'\n";
while (defined($line = <IN1>)) {
	
	if ($line =~ m/^(\S+)\s+(\d+)/) {
		# get the name and length of the proteins
		($name, $length) = ($1,$2);
		
		# insert to hash of lengths, with the name as a key.
		$proteinLengths{$name} = $length;
	} else { die "bad line format in '$inFile1': '$line'"; }
}
close(IN1);

# Read second file and compare to the hash
open (IN2, "<$inFile2") or die "Can't open file '$inFile2'\n";
while (defined($line = <IN2>)) {
	if ($line =~ m/^(\S+)\s+(\d+)/) {
		# get the name and length of the proteins
		($name, $length) = ($1,$2);
		
		# check if protein in hash
		if (exists($proteinLengths{$name})) {
			
			# print protein name if size equal
			if ($proteinLengths{$name} == $length) {
				print "$name\n";

			# print warning name if size not equal
			} else {
				print "$name appears with different lengths!\n";
			}
		}
	} else { die "bad line format in '$inFile2': '$line'"; }
}
close(IN2);
