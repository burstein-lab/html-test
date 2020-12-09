use strict;

print "Enter numbers on separate lines\n";
my $number;
my @lines = <STDIN>;
foreach $number (@lines) {
	print(($number*10) . "\n");
}
