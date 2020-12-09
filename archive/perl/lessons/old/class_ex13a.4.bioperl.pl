use strict;
#####################################################
# Purpose: Filter short sequences from FASTA file
# Parameters: Input and output FASTA file names
# Output: A FASTA file with all sequences shorter than 3000 bases
#####################################################

use Bio::SeqIO;

# Open input file
if (scalar(@ARGV) < 2) {die "USAGE: class_ex.pl INPUT_FILE OUTPUT_FILE\n";}
my ($inFile, $outFile) = @ARGV;

my $in = new Bio::SeqIO(	"-file" => "<$inFile",
       						"-format" => "FASTA");
my $out = new Bio::SeqIO(	"-file" => ">$outFile",
       						"-format" => "FASTA");

# pass on every sequence in the file
while ( my $seqObj = $in->next_seq() ) {

	# print sequences of length < 3,000
	if ($seqObj->length() < 3000){
		$out->write_seq($seqObj->revcom);
	}
}