###########################################################
# Purpose: Store levels of proteins in array within a hash
#
# $protData{ $protName }{"length"}   = $length
# $protData{ $protName }{"location"} = $location
#
# Output: the location of every protein
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

# Get all the protein (keys of %protData)
my @proteins = keys %protData;

# Get for each protein its location and print it out
foreach my $protName (@proteins) {
	my $protLocation = $protData{$protName}{"location"};
	print "The location of $protName is: $protLocation\n";
}

# Close input file
close(IN);