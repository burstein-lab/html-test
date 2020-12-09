######################################
# Purpose: Store names and phone numbers in a hash,
# and allow the user to ask for the number of a certain name.
# Input: Enter name-number pairs, enter "END" as a name to stop,
# then enter a name to get his/her number
#
use strict;

my ($name, $number);
my %phoneNumbers = ();

# Ask user for names and numbers and store in a hash
$name = "";
while ($name ne "END") {
	print "Enter a name that will be added to the phone book: \n";
	chomp($name = <STDIN>);
    if ($name eq "END") {last;}
	print "Enter a phone number: \n";
	chomp($number = <STDIN>);
	$phoneNumbers{$name} = $number;
}

# Ask for a name and print the corresponding number
$name = "";
while ($name ne "END") {
	print "Enter a name that will be search for in the phone book: \n";
	chomp($name = <STDIN>);
	if (exists($phoneNumbers{$name})) {
		print "The phone number of $name is: $phoneNumbers{$name}\n";
	}
    elsif ($name eq "END") {last;}
    else {
		print "Name not found in the book\n";
	}
}
