use strict;

# open file
my ($inFile) = @ARGV;
open (IN, "<$inFile") or die "cannot open $inFile";
# read all lines
my @lines = <IN>;

my $i=0; # word counter

#pass on each line and print the i-th word
foreach my $line (@lines) {
	my @splitted = split (/ /,$line);
	if (defined $splitted[$i]) {
		print "$splitted[$i]\n"
	}
	$i++; # increment counter
}

# close file
close (IN); 
