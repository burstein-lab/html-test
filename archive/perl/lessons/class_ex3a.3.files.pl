use strict;

# open input and output files
my $inFile = 'D:\perl_ex\numbers.txt';
my $outFile = 'D:\perl_ex\sum.txt';
open(IN, "<$inFile") or die "cannot open $inFile";
open(OUT, ">$outFile") or die "cannot open $outFile";

# read first three numbers
my $num1 = <IN>;
my $num2 = <IN>;
my $num3 = <IN>;

# calculate sum and print it out
my $sum = $num1 + $num2 + $num3;
print OUT "The sum of the first 3 numbers is: $sum";

# close input and output files
close(IN);
close(OUT);


