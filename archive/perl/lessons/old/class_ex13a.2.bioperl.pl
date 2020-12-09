use strict;
#####################################################
# Purpose: Filter short sequences from FASTA file
# Parameters: Input FASTA file name
# Output: A FASTA file with all sequences shorter than 3000 bases
#####################################################

use Bio::SeqIO;

# Open input file
if (scalar(@ARGV) < 1) {die "USAGE: class_ex.pl INPUT_FILE\n";}
my ($inFile) = @ARGV;

my $in = new Bio::SeqIO(	"-file" => "<$inFile",
       						"-format" => "FASTA");

# pass on every sequence in the file
while ( my $seqObj = $in->next_seq() ) {

	# compile header from id and description
	my $header = $seqObj->id()." ".$seqObj->desc();
	# print header if header contains "mus musculus"
	if ($header =~ m/mus musculus/i){
		print "$header\n";
	}
}