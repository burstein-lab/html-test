use strict;

print "Enter a list of numbers:\n";
my $numbers = <STDIN>;
my @numbers = split(/ /, $numbers);
my @reversed_numbers = reverse(@numbers);
my $joined = join("/", @reversed_numbers);
print "$joined\n";

# print join("/", reverse(split(" ", <STDIN>)));