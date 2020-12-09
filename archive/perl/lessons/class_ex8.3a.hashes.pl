#########################################################################
# Purpose: store and print a single year for each journal from a GenPept
# Parameters: input GenPept file
# Output: for each journal appearing in the GenPept file - one year
# in which an article appearing in the file was published
#########################################################################

use strict;

if (scalar(@ARGV) < 1) {die "USAGE: $0 <GenPept file>\n";}
my ($inFile) = @ARGV;

my (@lines, $line, $journalName, $year, %journalHash);

# open GenPept file and read into array
open(GENPEPT, "<$inFile") or die "Can't open file $inFile\n";
@lines = <GENPEPT>;
close(GENPEPT);

# pass through line and search JOURNAL lines
foreach $line (@lines){
	if ($line =~ m/JOURNAL\s+(\D+)\s.*\((\d{4})\)/) {
		# get journal name and year of publication
		$journalName = $1;
		$year = $2;

		# if name not in hash add name as key and year as value
		if (!exists( $journalHash{$journalName} ) ){
			$journalHash{$journalName} = $year;
		}
	}
}
my @keys = keys(%journalHash);
my @sortedKeys = sort(@keys);
foreach $journalName (@sortedKeys){
	print "$journalName - $journalHash{$journalName}\n";
}
