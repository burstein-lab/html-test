use strict;

# read list of numbers
print "Enter a line of words:\n";
my $words = <STDIN>;
chomp $words;

# Split the list
my @wordArr = split(/ /, $words);

# Sort and print the last word after the sort
my @sortedArr = sort(@wordArr);
print "$sortedArr[$#sortedArr]";