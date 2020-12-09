use strict;

####################################################################
# Purpose: Test the printSum subroutine
####################################################################
print "Please enter a number\n";
my $num1 = <STDIN>;
chomp $num1;
print "Please enter another number\n";
my $num2 = <STDIN>;
chomp $num2;


my @answerArr = numbersFunc($num1,$num2);
print "The sum, difference, and average of - $num1 and $num2 is:\n @answerArr \n";

####################################################################
# printSum subrountine 
# 
# Parameters: two numbers
# Output: a list of their: sum, difference, nd average
####################################################################
sub numbersFunc {
	my ($a,$b) = @_;
	my $sum = $a+$b;
	my $diff = $a-$b;
	my $average = ($a+$b)/2;
	return ($sum, $diff, $average);
}