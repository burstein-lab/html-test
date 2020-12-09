###############################################################
# Purpose: Read PTT files headers and store in a data structure
# the strand, the length and the product. 
# The Synonym will serve as the key:
#
# $pttHash{ $synonym }->{"strand"}  = $strand
# $pttHash{ $synonym }->{"length"}  = $length
# $pttHash{ $synonym }->{"product"} = $product
#
# Output: product and synonyms of all proteins > 1400aa coded 
#         on the positive strand.
#############################################################

use strict;

# Open and read input file
if (scalar(@ARGV) < 1) {die "PTT file missing\n";}
my ($inFile) = @ARGV;
open(IN,"<$inFile") or die "Can't open file $inFile\n";
my @pttLines = <IN>;
chomp @pttLines;

# read ptt file and find the Synonym and product
my (%pttHash, $strand , $length, $synonym, $product);
foreach my $line (@pttLines){
	if ($line =~ m/\d+\.\.\d+\t([+-])\t(\d+)\t\d+\t\S+\t(b\d{4})\t\S+\t\S+\t(.*)/){
		$strand = $1;
		$length = $2;
		$synonym = $3;
		$product = $4;
		$pttHash{$synonym}->{"strand"}  = $strand;
		$pttHash{$synonym}->{"length"}  = $length;
		$pttHash{$synonym}->{"product"} = $product;
	}
}

# pass on all the synonyms.
my @synonymArr = sort(keys %pttHash);
print "The following are of protein longer than 1400aa and coded on the positive strand:\n";
foreach $synonym (@synonymArr){
	#check that length is higher than 1400s and the strand is positive
	if ($pttHash{$synonym}->{"length"} > 1400 and $pttHash{$synonym}->{"strand"} eq "+") {
		$product = $pttHash{$synonym}->{"product"};
		print "Synonym: $synonym, product: $product\n";
	} 
}

# Close input file
close(IN);