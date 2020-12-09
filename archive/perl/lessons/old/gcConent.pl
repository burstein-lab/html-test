use strict;
######################################
# Purpose: Find G+C content of sequences
# Input: Sequences in FASTA format
# Output: For each header its G+C content
#

###################################
# 1. Foreach sequene in the input #
###################################
print "Please enter FASTA format data\n";
print "To finish typing, please press Ctrl+z and press ENTER\n";

my $fastaLine = <STDIN>;    
my $seq;
my $header;
while (defined $fastaLine) {
	$seq ="";  # Initialize seq to empty string
	#############################################
	### 1.1. Read sequence name from FASTA header
	chomp $fastaLine;
	$header = substr($fastaLine,1);
	$fastaLine = <STDIN>;
	
	##############################################
	### 1.2. Read sequence until next FASTA header
	while ((defined $fastaLine) and
		  (substr($fastaLine,0,1) ne ">" ))
	{
		chomp $fastaLine;
		$seq .= $fastaLine;
		$fastaLine = <STDIN>;
	}
 ####################		
 # 2. Do something: #
 ####################
 
	#############################
 	### 2.1. Compute G+C content 
	my $gcCount=0;
	my @seqArr = split(//,$seq);
	foreach my $nuc (@seqArr){
		if ($nuc eq "C" or $nuc eq "G") {
			$gcCount++;
		}		
	}
	my $gcConent = $gcCount/length($seq);
	
	######################################
	### 2.2.  Print header and G+C content
	print "$header\n";
	print "GC content: $gcConent\n"
}




