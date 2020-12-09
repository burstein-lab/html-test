##################################################################
# Purpose: Read a GenBank File, store in hash that uses
# product as key and an array of coordinated of the CDS as value 
#
# $genBank{ $product }{"protein_id"} 	= $protein_id;
# $genBank{ $product }{"db_xref"} 	= $db_xref;
#
# Output: Print protein_id and db_xref for protein entered by user
###################################################################
use strict;

# Open and read input file
open(IN,"<adeno12.gb") or die "Can't open file adeno12.gb";
my @genBanklines = <IN>;
chomp @genBanklines;

# read each line, and search for product and CDS line
my %genBank;
my ($product, $protein_id, $db_xref);
foreach my $line (@genBanklines){
	# Save product from product lines, such as:
	# '                    /product="E1A"'
	if ($line =~ m/\s+\/product=\"([^"]+)\"/){
		$product = $1;
	}
	# Save protein_id from protein_id lines, such as:
	# '                     /protein_id="AP_000107.1"'
	# and insert protein_id to data structure
	if ($line =~ m/\s+\/protein_id=\"([^"]+)\"/){
		$protein_id = $1;
		$genBank{$product}{"protein_id"} = $protein_id;
	}
	# Save db_xref from db_xref lines, such as:
	# '                     /db_xref="GI:56160437""'
	# and insert db_xref to data structure if product is defined.
	if ($line =~ m/\s+\/db_xref=\"([^"]+)\"/ and defined $product){
		$db_xref = $1;
		$genBank{$product}{"db_xref"} = $db_xref;
	}
}

# Ask user for a product 
print "For which product you want to recieve information about\n";
my $userProduct = <STDIN>;
chomp $userProduct;

# print the protein_id and db_xref of the user product if exists in hash.
if (exists $genBank{$userProduct}) {
	my $userProtein_id = $genBank{$userProduct}{"protein_id"};
	print "The protein_id of $userProduct is: $userProtein_id\n";
	
	my $userDb_xref = $genBank{$userProduct}{"db_xref"};
	print "The db_xref of $userProduct is: $userDb_xref\n";
} 
else {
	print "Sorry, $userProduct not found in my hash...\n";	
}

# Close input file
close(IN);