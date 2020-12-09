use strict;
##############################################################
# Purpose: Find length of sequences
# Input: File of Sequences in FASTA format (given by the user)
#        Output file name (also provided by the user)
# Output: For each header its length (into the output file)
#

###################################
# 1. Foreach sequene in the input #
###################################

# get input and output files.
print "Please enter name of FASTA file (use full path)\n";
my $inFileName = <STDIN>;
print "Please enter name of output file (use full path)\n";
my $outFileName = <STDIN>;
open(IN, "<$inFileName") or die "can't open file $inFileName";
open(OUT, ">$outFileName") or die "can't open file $outFileName";

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
 #########################################		
 # 2. Do something: print length to file #
 #########################################
 
	print OUT "$header\n";
	print OUT "Length: ".length($seq)."\n";
}




