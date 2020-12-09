###########################################################
# Purpose: Read FASTA headers and store in a hash the 
# information of the gi number and the sequence:
#
# $fasta{ $gi } = $ref
#
# Output: ref accession of gi entered by user.
#############################################################

use strict;

# Open and read input file
if (scalar(@ARGV) < 1) {die "Fasta file missing\n";}
my ($inFile) = @ARGV;
open(IN,"<$inFile") or die "Can't open file $inFile\n";

# read fasta file and process headers
my (%fasta,$header, $gi, $ref);
my $fastaLine = <IN>;
while (defined $fastaLine) {
	chomp $fastaLine;
	$header = substr($fastaLine,1);
	# get gi number and ref accession of headers, such as:
	#'>gi|16127995|ref|NP_414542.1| thr operon leader peptide [Escherichia coli str. K-12 substr. MG1655]'
	if ($fastaLine =~ m/^>gi\|(\d+)\|ref\|([^|]+)\|/) {
		$gi  = $1;
		$ref = $2; 
		$fasta{$gi} = $ref;
	}
	$fastaLine = <IN>;
}

# Ask user for a gi number 
print "Which gi are you interested in?\n";
my $userGi = <STDIN>;
chomp $userGi;
# check that indeed gi number exist in the hash
# if so - print sequence
if (exists $fasta{$userGi}) {
	my $userRef = $fasta{$userGi};
	print "The ref accession of GI $userGi is:\n";
	print "$userRef\n";
}
else {
	print "Sorry could not find this gi number...\n";
}

# Close input file
close(IN);