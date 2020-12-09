#########################################################################
# Purpose: store and print a single year for each journal from a GenPept 
# Parameters: input GenPept file
# Output: for each journal appearing in the GenPept file - *all the years*
# in which articles appearing in the file were published  
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
		# if journal in hash concatenate year to value
		if (exists($journalHash{$journalName}) ){
			$journalHash{$journalName} = $journalHash{$journalName} .", $year";
			
		# if not in hash add it			
		} else {
			$journalHash{$journalName} = $year;
		}	
	}
}

my @keys = keys(%journalHash);
my @sortedKeys = sort(@keys);
foreach $journalName (@sortedKeys){
	print "$journalName - $journalHash{$journalName}\n";
}

### and if you wish to sort years:
print "\nAnd now with years sorted:\n";
print "==========================\n";

my ($yearList,@yearArr,$sortedYearList);
foreach $journalName (@sortedKeys){
	# split according to /, / and join the array after sorting 
	$yearList = $journalHash{$journalName};
	@yearArr = 	split(/, /,$yearList);
	$sortedYearList = join (", ",sort(@yearArr));
	print "$journalName - $sortedYearList\n";
}
