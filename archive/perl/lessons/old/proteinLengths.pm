#####################################################
# Purpose: Reading protein names and lengths from files and comparing them
#####################################################

package proteinLengths;

use strict;

####################################################################
# readProteinLengthsFile subrountine 
# 
# Parameter: protein lengths filename
# Output: protein hash, with the name as key and the length as value.
#         $proteinLength{NAME} = LENGTH
####################################################################
sub readProteinLengthsFile {
	# open file
	my ($fileName) = @_;
	open(IN, $fileName) or die "Can't open file '$fileName'\n";
	my @lines = <IN>;
	close(IN);

	my ($line, $name, $length, %proteinLengths);
	foreach $line (@lines) {
		# get name and length of proteins
		if ($line =~ m/^(\S+)\s+(\d+)/) {
			($name, $length) = ($1,$2);
			# insert protein length to protein hash
			$proteinLengths{$name} = $length;
		} else { die "bad line format: '$line'"; }
	}
	
	# return reference to protein hash  
	return \%proteinLengths;
}

####################################################################
# compareProtLength subrountine 
# 
# Parameters: protein name, protein length, hash of protein lengths
# Output: 0 if protein does not exist in hash
#         1 if protein exists in hash with the same length
#         2 if protein exists in hash but with different length
####################################################################
sub compareProtLength {
	my ($name,$length,$proteinLengths) = @_;
	my %proteinHash = %{$proteinLengths};
	if (exists($proteinHash{$name})) {
		if ($proteinHash{$name} == $length) {
			return 1;
		} else {
			return 2;
		}
	} else { return 0; }
}

1;