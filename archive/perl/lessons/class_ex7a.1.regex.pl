use strict;
######################################
# Purpose: Extract annotations from a Genbank genomic record
# Parameters: Input file name
#

# open input file
if (scalar(@ARGV) < 1) {die "USAGE: class_ex.pl INPUT_FILE\n";}
my ($inFile) = @ARGV;
open (IN, "<$inFile") or die "Can't open file '$inFile'\n";

my @lines = <IN>; 
my $productCnt = 0;	# product counter

foreach my $line(@lines) {
	chomp $line;

	# Extract protein IDs.
	# e.g.   /protein_id="AP_000116.1"
	if ($line =~ m/^\s*\/product="([^"]+)"/) {
		print "product: $1\n";
		$productCnt++;
	}
}
print "found $productCnt products.\n";
close(IN);


	















