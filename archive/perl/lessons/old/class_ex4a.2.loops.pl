use strict;

#####################################################
# Purpose: Calculate sum of expenses for each person
# Input: A name and a list of expenses one in each line:
# Yossi
# +6.10
# +16.50
# +5.00
# Dana
# +21.00
# +6.00
# Refael
# +6.10
# +24.00
# +7.00
# +8.00
# Output: A name and the sum of expenses on the same line:
# Yossi 27.6
# Dana 27
# Refael 45.1
#####################################################
my ($line, @nameAndNums, $name, @nums, $num, $sum);

$line = <STDIN>;
chomp $line;

# A loop to process one input line at a time and print the output for that line
while ($line ne "END") {
    # Assume that the name was read from <STDIN> before the loop begins
    $name = $line;

    # Read and sum numbers
    $sum = 0;
    $line = <STDIN>;
    chomp $line;
    while (substr($line,0,1) eq "+") {
		$sum = $sum + substr($line,1);
		$line = <STDIN>;
		chomp $line;
    }
    print "$name $sum\n";
}









