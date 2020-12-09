#####################################################
# Write a script that reads a file with a list of protein names, lengths and location:
# AP_000081	181	Nuc
# AP_000174	104	Cyt 
# AP_000138	145	Cyt
# stores the names of the sequences as hash keys,  and use "length" and "location" as keys within each protein.
#####################################################

use strict;


if (scalar(@ARGV) < 1) {die "USAGE: $0 INPUT_FILE1 INPUT_FILE2\n";}
my ($inFile1) = @ARGV;
my ($line, $name, $length,$location, %proteins);

# Read first file and store the data in a hash
open(IN1, "<$inFile1") or die "Can't open file '$inFile1'\n";
while (defined($line = <IN1>)) {
	
	if ($line =~ m/^(\S+)\s+(\d+)\s+(\w+)/) {
		# get the name and length of the proteins
		($name, $length,$location) = ($1,$2,$3);
		
		# insert to hash of lengths, with the name as a key.
		$proteins{$name}{"length"}  = $length;
		$proteins{$name}{"location"}  = $location;
	} else { die "bad line format in '$inFile1': '$line'"; }
}
close(IN1);

