use strict;

# Read a numbers separated by spaces
print "Enter a list of numbers:\n";
my $numbers = <STDIN>;
chomp $numbers;
# Split the list into an array and reverse it
my @numbers = split(/ /, $numbers);
my @reversed_numbers = reverse(@numbers);

# Join the array into a string separated by slashes and print
my $joined = join("/", @reversed_numbers);
print "$joined\n";

# print join("/", reverse(split(" ", <STDIN>)));