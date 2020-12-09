use strict;

####################################################################
# Purpose: Read file of proteins and their lengths
# Parameters: Input file with protein name and length on each line
# Output: The same lines ordered accodring to their lengths
####################################################################

if (scalar(@ARGV) < 1) {die "USAGE: class_ex.pl INPUT_FILE\n";}
my ($inFile) = @ARGV;

# read all files
open(IN,"<$inFile") or die "Cannot open $inFile...";
my @lines = <IN>;
chomp @lines;
my @sorted = sort sortLengths @lines;
print join("\n",@sorted);

####################################################################
# sort numerically acoording to second word subrountine 
# 
# Parameter: array of lines with numbers as second word (after space)
####################################################################
sub sortLengths {
	my ($aVal,$bVal);
	$a =~ m/\S+\s+(\S+)/;
	$aVal = $1;
	$b =~ m/\S+\s+(\S+)/;
	$bVal = $1;
	
	return($aVal <=> $bVal);
}