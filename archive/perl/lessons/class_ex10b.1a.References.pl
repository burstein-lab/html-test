##################################################################
# Purpose: Store proteins information in complex data structure
#
# $protData{ $protName }{"length"}   = $length
# $protData{ $protName }{"location"} = $location
# $protData{ $protName }{"levels"}   = [ @levels ]
#
# Output: length, location  and levels of protein entered by user
##################################################################

use strict;

# Open and read input file
open(IN,"<proteinFullData.txt") or die "Can't open file proteinLengthsAndLocation.txt\n";
my @protLines = <IN>;
chomp @protLines;

# read each line, and had to protein hash
my %protData;
my ($protName, $length, $location);
foreach my $line (@protLines){
	# check line in correct format and extract name and levels. Such as:
	# "AP_000081	181	Nuc"
	if ($line =~ m/(\w+)\s+(\d+)\s+(\w+)\s+(\S+)/){
		my $protName = $1;
		my $length = $2;
		my $location = $3;
		my @levels = split(/,/,$4);				

		# insert length, location and levels to hash with protein name as a key
		$protData{$protName}{"length"}   = $length;
		$protData{$protName}{"location"} = $location;
		$protData{$protName}{"levels"}   = [ @levels ];
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

	#Get protein levels
	my @levelArr = @{$protData{$userProt}{"levels"}};
	my @sortedLevelArr = sort(@levelArr);
	print "The protein levels of $userProt are:\n";
	print "@sortedLevelArr\n";
}
else {
	print "Sorry could not find this protein...\n";
}

# Close input file
close(IN);