#########################################################################
# Purpose: store and print a single year for each journal from a GenPept
# Parameters: input GenPept file
# Output: for each journal appearing in the GenPept file - one year
# in which an article appearing in the file was published
#########################################################################

use strict;

if (scalar(@ARGV) < 1) {die "USAGE: $0 <GenPept file>\n";}
my ($inFile) = @ARGV;

my %pttHash;

# open GenPept file and read into array
open(PTT, "<$inFile") or die "Can't open file $inFile\n";
my @lines = <PTT>;
close(PTT);

# pass through table and update hash with synonym as key and length as value
foreach my $line (@lines){
	# look for lines such as:
	# 190..255	+	21	16127995	thrL	b0001	-	-	thr operon leader peptide
	# and catch length and synonym
	if ($line =~ m/^\d+\.\.\d+\t[+-]\t(\d+)\t\d+\t\S+\t(\S+)/) {
		# get journal name and year of publication
		my ($length, $synonym) = ($1,$2);
		$pttHash{$synonym} = $length;
	}
}
