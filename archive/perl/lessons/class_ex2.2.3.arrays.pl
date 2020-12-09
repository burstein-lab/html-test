use strict;

# Read the list
my @wordArr = @ARGV;

# Sort and print
my @sortedArr = sort(@wordArr);
print $sortedArr[$#sortedArr];