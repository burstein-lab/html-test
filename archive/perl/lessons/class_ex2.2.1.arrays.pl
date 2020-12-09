use strict;

# Read the numbers from the command line
my @numbers = @ARGV;

# Reverse the order
my @reversed_numbers = reverse(@numbers);

# Separate the numbers with slashes and print
my $joined = join("/", @reversed_numbers);
print "$joined\n";

