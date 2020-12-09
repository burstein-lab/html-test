###########################################################
# Purpose: Store levels of proteins in array within a hash
#
# $protData{ $protName }{"length"}   = $length
# $protData{ $protName }{"location"} = $location
#
# Output: length and location of protein entered by user
#############################################################

use strict;

# Open and read input file
open(IN,"<proteinLengthsAndLocation.txt") or die "Can't open file proteinLengthsAndLocation.txt\n";
my @protLines = <IN>;
chomp @protLines;

# read each line, and had to protein hash
my %protData;
my ($protName, $length, $location);
foreach my $line (@protLines){
	# check line in correct format and extract name and levels. Such as:
	# "AP_000081	181	Nuc"
	if ($line =~ m/(\w+)\s+(\d+)\s+(\w+)/){
		my $protName = $1;
		my $length = $2;
		my $location = $3;
		
		# insert length and location to hash with protein name as a key
		$protData{$protName}{"length"}   = $length;
		$protData{$protName}{"location"} = $location;
	}	
}

# Ask user for protein and print it sorted array of levels
print "Which protein are you interested in?\n";
my $userProt = <STDIN>;
chomp $userProt;
# check that indeed inserted protein exist in the hash
# if so - print its length and location
if (exists $protData{$userProt}) {
	# Get protein length
	my $userProtLength = $protData{$userProt}{"length"}; 
	print "The length of $userProt is: $userProtLength.\n";
	
	#Get protein location
	my $userProtLocation = $protData{$userProt}{"location"}; 
	print "The location of $userProt is: $userProtLocation.\n";
}
else {
	print "Sorry could not find this protein...\n";
}

# Close input file
close(IN);