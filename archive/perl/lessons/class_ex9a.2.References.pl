###########################################################
# Purpose: Read a GenBank File, store in hash that uses
# product as key and an array of coordinated of the CDS as value 
#
# $genBank{ $product } = [ @coordinates ]
#
# Output: Print coordinated of product entered by user
#############################################################
use strict;

# Open and read input file
open(IN,"<adeno12.gb") or die "Can't open file adeno12.gb";
my @genBanklines = <IN>;
chomp @genBanklines;

# read each line, and search for product and CDS line
my %genBank;
my ($allCoordinates,@coordinates,$product);
foreach my $line (@genBanklines){
	
	# Find CDS lines, such as:
	# '     CDS             join(503..1070,1145..1377)'
	# and get all coordinates
	if ($line =~ m/^\s+CDS\D+([\d,.]+)/){
		$allCoordinates= $1;
		# split coordinates into array
		@coordinates = $1 =~ m/(\d+)/g;
	}
	# Find product lines, such as:
	# '                    /product="E1A"'
	if ($line =~ m/\s+\/product=\"([^"]+)\"/){
		$product = $1;
		$genBank{$product} = [@coordinates];
	}
}

# Ask user for a product 
print "For which product you want to recieve the coordinates?\n";
my $userProduct = <STDIN>;
chomp $userProduct;

# print out the coordinates of the user product if exists in hash.
if (exists $genBank{$userProduct}) {
	my @userCoordinates = @{ $genBank{$userProduct} };
	print "The coordinates of $userProduct are:\n";
	print "@userCoordinates\n";
} else {
	print "Sorry, $userProduct not found in my hash...\n";	
}

# Close input file
close(IN);