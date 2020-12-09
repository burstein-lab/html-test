###############################################################
# Purpose: Read PTT files headers and store in a data structure
# the coordinates, the strand, the length and the product. 
# The Synonym will serve as the key:
#
# $pttHash{ $synonym }->{"strand"}  = $strand
# $pttHash{ $synonym }->{"length"}  = $length
# $pttHash{ $synonym }->{"product"} = $product
# $pttHash{ $synonym }->{"location"}   = [$start, $end]
# 
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
my (%pttHash, @location, $strand , $length, $synonym, $product);
foreach my $line (@pttLines){
	if ($line =~ m/(\d+)\.\.(\d+)\t([+-])\t(\d+)\t\d+\t\S+\t(b\d{4})\t\S+\t\S+\t(.*)/){
		@location = ($1, $2);
		
		$strand = $3;
		$length = $4;
		$synonym = $5;
		$product = $6;
		
		$pttHash{$synonym}->{"location"}  = [@location];
		
		$pttHash{$synonym}->{"strand"}  = $strand;
		$pttHash{$synonym}->{"length"}  = $length;
		$pttHash{$synonym}->{"product"} = $product;
	}
}

# get start and end values from user.
print "Please enter start coordinate\n";
my $userStart = <STDIN>;
chomp $userStart;
print "Please enter end coordinate\n";
my $userEnd = <STDIN>;
chomp $userEnd;

# pass on all the synonyms.
my @synonymArr = sort(keys %pttHash);
print "The following are between the $userStart and $userEnd of the E.coli genome:\n";
foreach $synonym (@synonymArr){
	#check that length is higher than 1400s and the strand is positive
	@location = @{ $pttHash{$synonym}->{"location"} }; 
	if ($location[0] > $userStart and $location[1] < $userEnd) {
		print "location: ";
		print join("-",@location);
		$product = $pttHash{$synonym}->{"product"};
		print " Synonym: $synonym, product: $product\n";
	} 
}

# Close input file
close(IN);