use strict;

print "Please enter your grades average:\n";
my $number = <STDIN>;
if ($number > 90) {
    print "wow!\n";
} elsif ($number > 80) {
    print "well done.\n";
} else {
    print "oh well...\n";
}
