use strict;

#####################################################
# Purpose: sum arguments
# Input: numeric arguments
# Output: Their sum
#####################################################

my $sum = 0;
foreach my $num (@ARGV) {
	$sum += $num;
}

print "the sum is $sum\n";