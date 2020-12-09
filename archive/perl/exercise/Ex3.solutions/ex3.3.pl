use strict;
############################################################################
# Usage: ex3.3.pl <Fasta filename>
#
# Input  : A filename of a file containing file in Fasta format
#          (provided as command-line argument)
# Output : For each header its first 30 characters

###################################
# 1. Foreach sequene in the input #
###################################

if (@ARGV != 1) {die "Usage: $0 <Fasta filename>";}

# open input file
my ($inFilename) = @ARGV;
open (IN, "<$inFilename") or die "Can't open $inFilename";

my $fastaLine = <IN>;    
my $seq;
my $header;
while (defined $fastaLine) {
	$seq ="";  # Initialize seq to empty string
	#############################################
	### 1.1. Read sequence name from FASTA header
	chomp $fastaLine;
	$header = substr($fastaLine,1);
	$fastaLine = <IN>;
	
	##############################################
	### 1.2. Read sequence until next FASTA header
	while ((defined $fastaLine) and
		  (substr($fastaLine,0,1) ne ">" ))
	{
		chomp $fastaLine;
		$seq .= $fastaLine;
		$fastaLine = <IN>;
	}
 ##############################################		
 # 2. Do something: print first 30 characters #
 ##############################################
 
	print "$header\n";
	print "First 30aa: ".substr($seq,0,30)."\n";
}




