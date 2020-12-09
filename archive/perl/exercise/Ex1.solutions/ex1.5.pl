use strict;

print "Enter a line\n";
my $line = <STDIN>;
my $substr = substr($line, 0, 3);
print "First 3 characters of the line are: $substr\n";
