use strict;

####################################################################
# Purpose: Test the printSum subroutine
####################################################################

if (scalar(@ARGV) != 2) {die "USAGE: class_ex.pl NUMBER1 NUMBER2\n";}

my @answerArr = numbersFunc($ARGV[0],$ARGV[1]);
print "The sum, difference, and average of - $ARGV[0] and $ARGV[1] is:\n @answerArr \n";

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