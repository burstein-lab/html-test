use strict;

####################################################################
# Purpose: Find common records in two files
# Parameters: Two input file with protein name and length on each line
# Output: List of common protein names with identical length in both files
#####################################################################

# Open input file
if (scalar(@ARGV) < 2) {die "USAGE: class_ex.pl INPUT_FILE1 INPUT_FILE2\n";}
my ($inFile1, $inFile2) = @ARGV;

my $proteinLengths = readProteinLengthsFile($inFile1);

# Read second file and compare to the hash of the first file
my ($line, $name, $length);
open IN2, $inFile2 or die "Can't open file $inFile2\n";
while (defined($line = <IN2>)) {
	if ($line =~ m/^(\S+)\s+(\d+)/) {
		#get name and length and compare to hash of first file
		($name, $length) = ($1,$2);
		my $comp = compareProtLength($name,$length,$proteinLengths);
		
		# print name if exist in first file with same lengh or warning if exists, but with different length
		if ($comp == 1) {
			print "$name\n";
		} elsif ($comp == 2) {
			print "$name appears with different lengths!\n";
		}
	} else { die "bad line format: '$line'"; }
}

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
	open(IN, "<$fileName") or die "Can't open file '$fileName'\n";
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