use strict;

print "Please enter a number:\n";
my $number = <STDIN>;
if (($number % 7 == 0 and $number % 2 == 0) or $number == 99){
    print "MEGA Boom!!!\n";
}