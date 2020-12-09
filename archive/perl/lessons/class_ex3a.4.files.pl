use strict;

#open input file
my $inFile = 'D:\perl_ex\fight club.txt';
open(IN, "<$inFile") or die "cannot open $inFile";

#print 3rd line
my $line = <IN>;
$line = <IN>;
$line = <IN>;
print $line;

#print 5th line
$line = <IN>;
$line = <IN>;
print $line;

# close input file
close(IN);


