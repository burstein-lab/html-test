use strict;
######################################
# Get a journal name and the year of publication from the user (using <STDIN>), 
# find this paper in the adenovirus record and print the pages of this paper in the journal
# For example if the user types "J. Virol." and "1994" 
# print: "J. Virol. 68 (1), 379-389 (1994)" 
# but not: "J. Virol. 67 (2), 682-693 (1993)"

if (scalar(@ARGV) != 1) {die "USAGE: class_ex.pl INPUT_FILE\n";}
my ($inFile) = @ARGV;

# Get a journal name and the year of publication from the user
print "Type the journal name...\n";
my $journal = <STDIN>;
chomp($journal);

print "Type the year of publication...\n";
my $year = <STDIN>;
chomp($year);

# open input file
open (IN, "<$inFile") or die "Can't open file '$inFile'\n";
my @lines = <IN>;
foreach my $line (@lines) {
	chomp $line;

	# Find JOURNAL lines and extract page numbers, for $journal and $year
	# e.g.    JOURNAL   J. Virol. 68 (1), 379-389 (1994)
	if ($line =~ m/^\s*JOURNAL\s.*$journal.*\D\d+-\d+.*\($year\)/) {
		print "$line\n";
	}	
}
close(IN);
