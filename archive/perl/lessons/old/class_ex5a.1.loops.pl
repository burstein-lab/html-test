use strict;

#####################################################
# Purpose: Calculate sum of expenses for each person 
# Input: A name and a list of expenses on the same line (from a file):
# Yossi 6.10,16.50,5.00
# Dana 21.00,6.00
# Refael 6.10,24.00,7.00,8.00
# Output: A name and the sum of expenses on the same line:
# Yossi 27.6
# Dana 27
# Refael 45.1
#####################################################
my ($line, @nameAndNums, $name, @nums, $num, $sum);

my $inFileName = 'D:\perl_ex\class_ex4.1.input.txt';
open(IN, "<$inFileName") or die "can't open file $inFileName";
$line = <IN>;
chomp $line;

# A loop to process one input line at a time and print the output for that line
while ($line ne "END") {
    # Assume that the line was read from file before the loop begins
    # Separate name and numbers
    @nameAndNums = split(/ /, $line);
    $name = $nameAndNums[0];
    @nums = split(/,/, $nameAndNums[1]);
    $sum = 0;

    # Sum numbers
    foreach $num (@nums) {
		$sum = $sum + $num;
    }
    print "$name $sum\n";

    # Read next line
    $line = <IN>;
    chomp $line;
}
close(IN);
