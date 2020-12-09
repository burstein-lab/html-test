use strict;
############################################################################
# Usage: ex3.4.pl <GenPept filename>
#
# Input  : A filename of a file containing file in GenPept format
#          (provided as command-line argument)
# Output : The first line of each title 

if (@ARGV != 1) {die "Usage: $0 <GenPept filename>";}

# open input file
my ($inFilename) = @ARGV;
open (IN, "<$inFilename") or die "Can't open $inFilename";

# read input lines
my $title;
my $line = <IN>;
while (defined $line){
	chomp($line);
	# print TITLE line (the length must be checked to avoid an error in short lines)
	if ( (length($line) > 7) && (substr($line,2,5) eq "TITLE") ) {
		$title = substr($line,12);   # get the title
		print "$title\n";
	}
	$line = <IN>;
}

close (IN);
