use strict;

# open file
my ($inFile) = @ARGV;
open (IN, "<$inFile")  or die "cannot open $inFile";

# read all lines
my @lines = <IN>;
#pass on each line and print only those starting with '>'
foreach my $fastaLine (@lines) {
	if (substr($fastaLine,0,1) eq '>') {
		print $fastaLine;
	}
}

# close file
close (IN); 
