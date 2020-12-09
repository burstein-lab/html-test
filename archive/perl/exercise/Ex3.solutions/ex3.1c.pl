use strict;
############################################################################
# Usage: ex3.1b.pl <numbers filename>
#
# Input  : A filename of a file containing numbers, one on each line
# Output : smallest numer of numbers in file

if (@ARGV != 1) {die "Usage: $0 <numbers filename>";}

# open input file
my ($inFilename) = @ARGV;
open (IN, "<$inFilename") or die "Can't open $inFilename";

# read all numbers to an array 
my @numArr = <IN>;
chomp @numArr;

# set the smallest number to be the first one in the list
my $min = $numArr[0]; 
# pass on number array check every non empty number if it is smaller than the current minimum
foreach my $num (@numArr){
	if (length($num) > 0  and $num < $min){
		$min = $num;
	}
}

print "The minimum of the numbers in $inFilename is $min.\n";