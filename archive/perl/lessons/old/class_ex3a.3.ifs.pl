use strict;

print "Please enter your grades average:\n";
my $number = <STDIN>;
if ($number < 0 or $number > 100) {
    print "ERROR: The average must be between 0 and 100.\n";
} elsif ($number > 90) {
    print "wow!\n";
} elsif ($number > 80) {
    print "well done.\n";
} else {
    print "oh well...\n";
}
