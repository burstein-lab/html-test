use strict;

####################################################################
# Purpose: Test the printSum subroutine
####################################################################

if (scalar(@ARGV) != 2) {die "USAGE: class_ex.pl NUMBER1 NUMBER2\n";}

printSum($ARGV[0],$ARGV[1]);

####################################################################
# printSum subrountine 
# 
# Parameters: two numbers
# Output: the sum of these numbers
####################################################################
sub printSum {
	my ($a,$b) = @_;
	print(($a+$b) . "\n");
}