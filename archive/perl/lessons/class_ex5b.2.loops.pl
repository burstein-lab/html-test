use strict;

# open file
my ($inFile) = @ARGV;
open (IN, "<$inFile")  or die "cannot open $inFile";

## 1.1. Read FASTA header and save it
my $fastaLine = <IN>;
while (defined $fastaLine) {
	chomp $fastaLine;
	my $header = substr($fastaLine,1);
	## 1.2. Read seq until next header
	$fastaLine = <IN>;
	my $seq = "";
	while ((defined $fastaLine) and
		  (substr($fastaLine,0,1) ne ">" )) {
		chomp $fastaLine;
		$seq .= $fastaLine;
		$fastaLine = <IN>;
	}
	## 2.1 get first 3 aa
	my $subseq = substr($seq,0,3);
	## 2.2 print header if the first 3aa are MAD or MAN
	if ($subseq eq 'MAD' or $subseq eq 'MAN'){
		print "$subseq in the begining of:\n$header\n";
	} 
}





# close file
close (IN); 
