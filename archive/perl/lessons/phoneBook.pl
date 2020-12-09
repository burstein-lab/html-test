######################################
# Purpose: Store names and phone numbers in a hash,
# and allow the user to ask for the number of a certain name.
# Input: Enter name-number pairs, enter "END" as a name to stop,
# then enter a name to get his/her number
#
use strict;

my %phoneNumbers = ();
my $number;
my $name = "";

# Ask user for names and numbers and store in a hash
while ($name ne "END") {
	print "Enter a name that will be added to the phone book:\n";
	$name = <STDIN>;
	chomp $name;
    if ($name eq "END") {
    	last;
    }
	print "Enter a phone number: \n";
	$number = <STDIN>;
	chomp $number;
	$phoneNumbers{$name} = $number;
}

# Ask for a name and print the corresponding number
$name = "";
while ($name ne "END") {
	print "Enter a name to search for in the phone book:\n";
	$name = <STDIN>;
	chomp $name;
	if (exists($phoneNumbers{$name})) {
		print "The phone number of $name is: $phoneNumbers{$name}\n";
	}
    elsif ($name eq "END") {
    	last;
    }
    else {
		print "Name not found in the book\n";
	}
}
