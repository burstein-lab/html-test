use strict;
######################################
# Purpose: Extract annotations from a Genbank genomic record
# Parameters: Input file name

# open and read input file
if (scalar(@ARGV) != 1) {die "USAGE: class_ex.pl INPUT_FILE\n";}
my ($inFile) = @ARGV;
open (IN, "<$inFile") or die "Can't open file $inFile";
my @lines = <IN>;

my $proteins = 0;	#protein counter
# pass through all lines in file
foreach my $line (@lines) {
	chomp $line;

	# Find JOURNAL lines and extract page numbers
	# e.g.  JOURNAL   J. Gen. Virol. 84 (Pt 11), 2895-2908 (2003)
	if ($line =~ m/^\s*JOURNAL\s.*\s(\d+-\d+)/) {
		print "$1\n";
	}
	
	# Extract protein IDs.
	# e.g.   /protein_id="AP_000116.1"
	if ($line =~ m/^\s*\/protein_id="(\S+)"/) {
		print "protein $1\n";
		$proteins++;
	}
}
print "found $proteins protein IDs\n";
