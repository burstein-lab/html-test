##################################################################
# Purpose: Read a GenBank File, store in hash that uses
# product as key and an array of coordinated of the CDS as value 
#
# $genBank{ $product }{"protein_id"} 	= $protein_id;
# $genBank{ $product }{"db_xref"}    	= $db_xref;
# $genBank{ $product }{"strand"}	 	= $strand;    (+/-)
# $genBank{ $product }{"CDS"}		 	= [ @coordinates ]
#
# Output: Print protein_id,db_xref and coordintes for protein  
#		  entered by user on positive strand.
###################################################################
use strict;

# Open and read input file
open(IN,"<adeno12.gb") or die "Can't open file adeno12.gb";
my @genBanklines = <IN>;
chomp @genBanklines;

# read each line, and search for product and CDS line
my %genBank;
my ($product, $protein_id, $db_xref, $strand,$allCoordinates, @coordinates);
foreach my $line (@genBanklines){
	# Find CDS lines, such as:
	# '     CDS             complement(join(3844..5180,5459..5471))'
	# and  A) check wheather 'complement' exist
	#      B) Save the coordinates
	if ($line =~ m/^\s+CDS\s+(complement)?\D+([\d,.]+)/){
		# get strand 		 
		if (defined $1 and $1) {
			$strand = '-';
		}
		else {
			$strand = '+';
		}
		# split coordinates into array
		$allCoordinates = $2;
		@coordinates = $allCoordinates =~ m/(\d+)/g;
	}

	
	# Save product from product lines, such as:
	# '                    /product="E1A"'
	# use product as key and insert strand + CDS coordinates to data structure
	if ($line =~ m/\s+\/product=\"([^"]+)\"/){
		$product = $1;
		$genBank{$product}{"strand"} = $strand;
		$genBank{$product}{"CDS"}    = [ @coordinates ];
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
# Get all the product names (keys of %genBank)
my @products = keys %genBank;
my @CDS;
# print all the product names and db_xref of the proteins coded on negative strand.
foreach my $product (@products){
	if ( $genBank{$product}{"strand"} eq '+') {
		print "The product $product is coded on the positive  strand\n";
		@CDS = @{$genBank{$product}{"CDS"}};
		print "Its coordinates are: @CDS.\n\n";
	}
}

# Close input file
close(IN);