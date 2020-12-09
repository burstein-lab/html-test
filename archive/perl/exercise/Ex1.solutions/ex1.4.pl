use strict;

print "Enter a line\n";
my $line = <STDIN>;
chomp $line;
print "Length is " . (length $line) . "\n";
