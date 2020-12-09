use strict;
####################################################################
# Purpose: Test the lastWord subroutine
####################################################################
print "Enter a sentence:\n";
my $line = <STDIN>;
print(lastWord($line) . "\n");

####################################################################
# lastWord subrountine 
# 
# Parameter: a string
# Output: the last word in the string
####################################################################
sub lastWord {
	my ($line) = @_;
	
	# split string to words (separated by spaces) and get the last word
	my @words = split(/\s+/, $line);
	my $last = pop @words;
	return $last;
}