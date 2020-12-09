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

my @numArr = ($num1,$num2);
my $arrRef = numbersFunc(\@numArr);
my @answerArr = @{$arrRef};
print "The sum, difference, and average of - $num1 and $num2 is:\n @answerArr \n";

####################################################################
# printSum subrountine 
# 
# Parameters: two numbers
# Output: a list of their: sum, difference, nd average
####################################################################
sub numbersFunc {
	my ($arrRef) = @_;
	my $a = $arrRef->[0];
	my $b = $arrRef->[1];
	my $sum = $a+$b;
	my $diff = $a-$b;
	my $average = ($a+$b)/2;
	my @retArr = ($sum, $diff, $average); 
	return \@retArr;
}