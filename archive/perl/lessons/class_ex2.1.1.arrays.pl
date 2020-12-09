use strict;

print "Enter a line number:\n";
my $lineNumber = <STDIN>;
print "Enter a list of strings, end with ^Z:\n";
my @list = <STDIN>;
print $list[$lineNumber-1];
