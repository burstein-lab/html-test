###########################################################
# Purpose: Read PTT files headers and store in a hash the
# Synonym as a key and the Product as value
#
# $pttHash{ $synonym } = $product
#
# Output: ref accession of gi entered by user.
#############################################################

use strict;

# Open and read input file
if (scalar(@ARGV) < 1) {die "PTT file missing\n";}
my ($inFile) = @ARGV;
open(IN,"<$inFile") or die "Can't open file $inFile\n";
my @pttLines = <IN>;
chomp @pttLines;

# read ptt file and find the Synonym and product
my (%pttHash, $synonym, $product);
foreach my $line (@pttLines){
	if ($line =~ m/\d+\.\.\d+\t[+-]\t\d+\t\d+\t\S+\t(b\d{4})\t\S+\t\S+\t(.*)/){
		$synonym = $1;
		$product = $2;
		$pttHash{$synonym} = $product;
	}
}


# Ask user for a gi number 
print "Which synonym interest you?\n";
my $userSynonym = <STDIN>;
chomp $userSynonym;
# check that indeed gi number exist in the hash
# if so - print sequence
if (exists $pttHash{$userSynonym}) {
	my $userProduct = $pttHash{$userSynonym};
	print "The product of $userSynonym is: $userProduct\n";
}
else {
	print "Sorry could not find this synonym...\n";
}

# Close input file
close(IN);