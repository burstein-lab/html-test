use strict;

#open input file
my ($inFile) = @ARGV;
open(IN, "<$inFile") or die "cannot open $inFile";

# print first two lines
my $line = <IN>;
print $line;
$line = <IN>;
print $line;

# close input file
close(IN);

