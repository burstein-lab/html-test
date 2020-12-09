use strict;
####################################################################
# Purpose: Test the longestWord subroutine
####################################################################
print "Enter a sentence:\n";
my $line = <STDIN>;
my $wordFound = longestWord($line);
print "The word: " . $wordFound ." of ". length($wordFound). "\n";

####################################################################
# longestWord subrountine 
# 
# Parameter: a string
# Output: the longest word in the string 
# Notes: returns the first if among two of equal length
####################################################################
sub longestWord {
	my ($line) = @_;
	
	# split string to words (separated by spaces) and get the last word
	my @words = split(/\s+/, $line);
	my $longestWord = "";
	my $maxLength = 0;
	foreach my $word (@words){
		if(length($word) > $maxLength){
			$longestWord = $word;			
		}		
	}
	return $longestWord;
}