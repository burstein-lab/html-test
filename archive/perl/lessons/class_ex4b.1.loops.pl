use strict;

# open file
my ($inFile) = @ARGV;
open (IN, "<$inFile") or die "cannot open $inFile";

# read each line and print only those starting with '>' 
my $fastaLine = <IN>;
while (defined $fastaLine) {
	if (substr($fastaLine,0,1) eq '>') {
		print $fastaLine;
	}
	$fastaLine = <IN>;
}

# close file
close (IN); 
