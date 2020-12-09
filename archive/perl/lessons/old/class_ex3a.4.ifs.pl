use strict;

print "Please enter a number:\n";
my $number = <STDIN>;
if ($number % 7 == 0) {
    print "Boom!\n";
}