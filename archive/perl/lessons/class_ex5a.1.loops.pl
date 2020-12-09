use strict;

# open file
open (IN, "<fight club.txt") or die "cannot open fight club.txt";
# read all lines
my @lines = <IN>;
chomp @lines;

#pass on each line and print the number of words in each line
foreach my $line (@lines) {
	my @splitted = split (/ /,$line);
	print scalar(@splitted)."\n";
}

# close file
close (IN); 
