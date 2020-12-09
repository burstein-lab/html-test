use strict;

# Read an array and sort it
my @wordArr = @ARGV;
my @sortedArr = sort(@wordArr);

# Reverse the last word and print it
my $lastWord = $sortedArr[$#sortedArr];
my @lastWordArr = split(//,$lastWord);
@lastWordArr = reverse(@lastWordArr);
$lastWord = join("",@lastWordArr); 

#update the array and print
$sortedArr[$#sortedArr] = $lastWord; 
print "@sortedArr";