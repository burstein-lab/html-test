use strict;

# open input and output files
my $inFile = 'D:\perl_ex\fight club.txt';
my $outFile = 'D:\perl_ex\fight.one.txt';
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


