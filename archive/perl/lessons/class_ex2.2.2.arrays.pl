use strict;

# Read the list from the command line.
my @wordArr = @ARGV;

# Sort and print
my @sortedArr = sort(@wordArr);
print "@sortedArr";

