######################################
# Purpose: Store names and phone numbers in a hash,
# and allow the user to ask for the number of a certain name.
# Input: Enter name- Phone number » Address » ID number, enter "END" to stop (when name is asked).
# then enter a name and 
# Note: assume the imput is legal phones, address and ID
use strict;

my ($name, $number, $address, $IDnumber, $dataType);
my %phoneBook = ();

# Ask user for names and numbers and store in a hash
print "Note: we do not check the validity of your input... \n";
$name = "";
while ($name ne "END") {
	print "Enter a name that will be added to the phone book: \n";
	chomp($name = <STDIN>);
    if ($name eq "END") {last;}
	print "Enter a phone number: \n";
	chomp($number = <STDIN>);
	$phoneBook{$name}{'number'} = $number;
	
	print "Enter address: \n";
	chomp($address = <STDIN>);
	$phoneBook{$name}{'address'} = $address;
	
	print "Enter IDnumber: \n";
	chomp($IDnumber = <STDIN>);
	$phoneBook{$name}{'IDnumber'} = $IDnumber;	
}

# Ask for a name and dataType and print the corresponding data
$name = "";
$dataType = "";
while ($name ne "END") {
	print "Enter a name that will be search for in the phone book: \n";
	chomp($name = <STDIN>);
	print "Enter the dataType you require. one of: number, address, IDnumber: \n";
	chomp($dataType = <STDIN>);
	
	
	if (exists $phoneBook{$name}{$dataType} ) {
		print "The $dataType of $name is: $phoneBook{$name}{$dataType}\n";
	}
    elsif ($name eq "END") {last;}
    else{
		print "Data $dataType not found in the book for $name\n";
	}
}
