use strict;

####################################################################
# Purpose: Read file into a hash
# Parameters: Input file with protein name and length on each line
# Output: List of protein names
####################################################################

if (scalar(@ARGV) < 1) {die "USAGE: class_ex.pl INPUT_FILE\n";}
my ($inFile) = @ARGV;

# read the protein lengths files
my $proteinLengths = readProteinLengthsFile($inFile);
# print the keys of the hash
print join(" ", keys(%{$proteinLengths}));

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
	open(IN, $fileName) or die "Can't open file $fileName\n";
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