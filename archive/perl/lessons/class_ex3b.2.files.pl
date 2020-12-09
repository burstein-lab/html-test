use strict;

# open input and output files
my ($inFile,$outFile) = @ARGV;
open(IN, "<$inFile") or die "cannot open $inFile";
open(OUT, ">$outFile") or die "cannot open $outFile";

# read whole file to an array
my @lines= <IN>;

# print array to the output file 
chomp @lines;
print OUT "@lines";

# close input and output files
close(IN);
close(OUT);


