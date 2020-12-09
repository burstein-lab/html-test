use strict;
print "Please enter FASTA format data\n";
print "To finish typing, please press Ctrl+z and press ENTER\n";

my $fastaLine = <STDIN>;    
my $seq;
my $header;
while (defined $fastaLine) {
	$seq ="";  # Initialize seq to empty string
	### 1.1. Read sequence name from FASTA header
	chomp $fastaLine;
	$header = substr($fastaLine,1);
	$fastaLine = <STDIN>;
	### 1.2. Read sequence until next FASTA header
	while ((defined $fastaLine) and
		  (substr($fastaLine,0,1) ne ">" ))
	{
		chomp $fastaLine;
		$seq .= $fastaLine;
		$fastaLine = <STDIN>;
	}	
 ### 2. Do something:

	### 2.1. prints FASTA output of the sequences whose header starts with 'Chr07'.
	if (substr($header,0,5) eq "Chr07") {
		print ">$header\n";
		my @seqArr = split(//,$seq);
		my $i = 0;
		while ($i < scalar(@seqArr) ){
			print $seqArr[$i];
			if ($i%60 == 0 and $i>0){print "\n";}
			$i++;
		} 
	 }
}


