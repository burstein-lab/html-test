use strict;

# read list of numbers
print "Enter a line of words:\n";
my $words = <STDIN>;
my @wordArr = split(" ", $words);
my @sortedArr = sort(@wordArr);
$sortedArr[$#sortedArr] = reverse($sortedArr[$#sortedArr]); 
print "@sortedArr";

