use strict;

# Get grade from user
print "Please enter your grades average:\n";
my $number = <STDIN>;

# Print response to grade
if ($number > 90) {
    print "wow!\n";
} elsif ($number > 80) {
    print "well done.\n";
} else {
    print "oh well...\n";
}
