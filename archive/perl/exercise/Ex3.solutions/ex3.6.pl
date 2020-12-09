use strict;
############################################################################
# Usage: ex3.6.pl <GenPept filename>
#
# Input  : A filename of a file containing file in GenPept format
#          (provided as command-line argument)
# Output : LOCUS line and a sorted list of all the reference titles 

if (@ARGV != 1) {die "Usage: $0 <GenPept filename>";}

# open input file
my ($inFilename) = @ARGV;
open (IN, "<$inFilename") or die "Can't open $inFilename";

# read input lines
my $journal;
my $title;
my @titleArray;
my $line = <IN>;
while (defined $line){
	chomp($line);

	# if reached LOCUS line print it
	if ((substr($line,0,5) eq "LOCUS") ) {
	    print "\n$line\n";
	}

	# if reached TITLE start an inner loop until reaching the JOURNAL line
	if ( (length($line) > 7) && (substr($line,2,5) eq "TITLE") ) {
		while (substr($line,2,7) ne "JOURNAL") {
			$title = $title.substr($line,12);   # concatenate the title line
			chomp($line = <IN>);
		}
		# push entire title to title array
		push(@titleArray,$title); 
		$title="";
	}

	# if reached FEATURES line - sort and print titles array
	if ((substr($line,0,8) eq "FEATURES") ) {
		@titleArray = sort(@titleArray);
		foreach $title (@titleArray) {
			print "$title\n";
		}
		@titleArray = (); # empty title array 
	}

	$line = <IN>;
}

close (IN);
