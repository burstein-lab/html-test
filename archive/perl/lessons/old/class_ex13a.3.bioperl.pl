use strict;
#####################################################
# Purpose: Convert GenPept file into FASTA
# Parameters: Input GenPept file name
# Output: ouput FASTA file name
#####################################################
use Bio::SeqIO;

if (scalar(@ARGV) < 2) {die "USAGE: $0 INPUT_FILE\n";}
my ($genpept, $fastaFile) = @ARGV;

# loads the whole file into memory
my $inGenPept = new Bio::SeqIO(	"-file" => "<$genpept",
       		 					"-format" => "GenBank") or die "cannot find $ARGV[0]";
       						  
my $outFasta = new Bio::SeqIO(	"-file" => ">$fastaFile",
       							"-format" => "FASTA") or die "cannot find $ARGV[0]";

#pass on every sequence in the GenPept file
while ( my $seqObj = $inGenPept->next_seq() ) {
	# write sequence to FASTA file
	$outFasta->write_seq($seqObj);    
}
