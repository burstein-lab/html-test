use strict;

####################################################################
# Purpose: Test the printSum subroutine
####################################################################

print "Please enter a number\n";
my $num1 = <STDIN>;
print "Please enter another number\n";
my $num2 = <STDIN>;


printSum($num1,$num2);

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