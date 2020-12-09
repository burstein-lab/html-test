use strict;
############################################################################
# Usage: ex3.1a.pl <numbers filename>
#
# Input  : A filename of a file containing numbers, one on each line
# Output : Number of numbers in file

if (@ARGV != 1) {die "Usage: $0 <numbers filename>";}

# open input file
my ($inFilename) = @ARGV;
open (IN, "<$inFilename") or die "Can't open $inFilename";

# read all numbers to an array 
my @numArr = <IN>;
chomp @numArr;

# pass on number array and count all non empty elements of the array
my $counter = 0;
foreach my $num (@numArr){
	if (length($num) > 0 ){
		$counter++; 		# same as $counter = $counter + 1;
	}
}

print "The number of numbers in $inFilename is $counter.\n";