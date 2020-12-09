use strict;

print "Enter a line\n";
my $line = <STDIN>;

print "Enter 3 numbers in separate lines (first and second are positions in the above line, and the third is the number of duplications)\n";
my $start = <STDIN>;
my $end = <STDIN>;
my $copies = <STDIN>;

my $substr = substr($line, $start, $end-$start+1);
print ($substr x $copies);
