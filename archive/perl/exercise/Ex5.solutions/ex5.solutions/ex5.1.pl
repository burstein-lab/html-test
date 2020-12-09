use strict;

#####################################################
# Purpose: Calculate sum of expenses for each person
# Input: A file containing name and a list of expenses on each line:
# Yossi 6.10,16.50,5.00
# Dana 21.00,6.00
# Refael 6.10,24.00,7.00,8.00
# Then ask for a name and print the sum of expenses
#####################################################

# open input file
if (scalar(@ARGV) < 1) {die "USAGE: $0 INPUT_FILE\n";}
my ($inFileName) = @ARGV;
open (IN, "<$inFileName") or die "can't open '$inFileName'";

my ($line, @nameAndNums, $name, @nums, $num, $sum);
my %expenses;

# A loop to process one input line at a time and print the output for that line
foreach $line (<IN>) {
	chomp $line;

	# Separate name and numbers
	@nameAndNums = split(" ", $line);
	$name = $nameAndNums[0];
	@nums = split(",", $nameAndNums[1]);
	$sum = 0;
	
	# Sum numbers
	foreach $num (@nums) {
		$sum = $sum + $num;
	}
	$expenses{$name} = $sum;
}
close IN;

# Ask for a id and print the sum of expenses
print "Enter a name:\n";
$name = <STDIN>;
chomp $name;
if (exists $expenses{$name}) {
	print $expenses{$name}, "\n";
} else {
	print "No such name\n";
}
