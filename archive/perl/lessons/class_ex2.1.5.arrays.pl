use strict;

# read list of numbers
print "Enter a line of words:\n";
my $words = <STDIN>;
chomp $words;

# Create an array and sort it
my @wordArr = split(/ /, $words);
my @sortedArr = sort(@wordArr);

# Reverse the last word and print it
my $lastWord = $sortedArr[$#sortedArr];
my @lastWordArr = split(//,$lastWord);
@lastWordArr = reverse(@lastWordArr);
$lastWord = join("",@lastWordArr); 

#update the array and print
$sortedArr[$#sortedArr] = $lastWord; 
print "@sortedArr\n";