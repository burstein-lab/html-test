use strict;
############################################################################
# Usage: ex3.1b.pl <numbers filename>
#
# Input  : A filename of a file containing numbers, one on each line
# Output : sum of numbers in file

if (@ARGV != 1) {die "Usage: $0 <numbers filename>";}

# open input file
my ($inFilename) = @ARGV;
open (IN, "<$inFilename") or die "Can't open $inFilename";

# read all numbers to an array 
my @numArr = <IN>;
chomp @numArr;

# pass on number array and sum all non empty elements of the array
my $sum = 0;
foreach my $num (@numArr){
	if (length($num) > 0 ){
		$sum = $sum + $num; 		# You can do it shotly by: $sum += $num;
	}
}

print "The sum of the numbers in $inFilename is $sum.\n";