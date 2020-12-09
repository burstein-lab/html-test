use strict;
############################################################################
# Usage: ex3.5.pl <GenPept filename>
#
# Input  : A filename of a file containing file in GenPept format
#          (provided as command-line argument)
# Output : The full titles

if (@ARGV != 1) {die "Usage: $0 <GenPept filename>";}

# open input file
my ($inFilename) = @ARGV;
open (IN, "<$inFilename") or die "Can't open $inFilename";

# read input lines
my $title="";
my $line = <IN>;
while (defined $line){
	chomp($line);

	# if reached title start an inner loop until reaching the JOURNAL line
	if ( (length($line) > 7) && (substr($line,2,5) eq "TITLE") ) {
		while (substr($line,2,7) ne "JOURNAL") {
			$title = $title . substr($line,12);   # concatenate the title line
			chomp($line = <IN>);
		}
		# print entire title, and initiate it
		print "$title\n"; 
		$title=""; 
	}
	$line = <IN>;
}

close (IN);
