use strict;

# read list of numbers
print "Enter a list of numbers:\n";
my $numbers = <STDIN>;
my @numbers = split(" ", $numbers);

# manipulate list
my $first_doubled = 2*shift(@numbers);
my $last_doubled = 2*pop(@numbers);
my @reversed_numbers = reverse(@numbers);

# print list
print ($last_doubled."/");
print join("/", @reversed_numbers);
print ("/".$first_doubled);

