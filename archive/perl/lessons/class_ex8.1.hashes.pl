#####################################################
# Purpose: Store lengths of proteins in a hash
# Parameters: Input file with protein name and length on each line
#####################################################

use strict;

# Open input file
if (scalar(@ARGV) < 1) {die "USAGE: $0 INPUT_FILE\n";}
open(IN,"<$ARGV[0]") or die "Can't open file '$ARGV[0]'\n";

my ($line, $name, $length, %proteinLengths); 
#Read each line that contains: <name> <length>
while (defined($line = <IN>)) {
	if ($line =~ m/^(\S+)\s+(\d+)/) {

		# get the name and length of the proteins
		$name = $1;
		$length = $2;

		# insert to hash of lengths, with the name as a key.
		$proteinLengths{$name} = $length;
	} else { die "bad line format: '$line'"; }
}

# prints the protein names (keys of hash)
my @keys = keys(%proteinLengths);
print "@keys";
