##################################################################
# Purpose: Store proteins information in complex data structure
#
# $protData{ $protName }{"length"}   = $length
# $protData{ $protName }{"location"} = $location
# $protData{ $protName }{"levels"}   = [ @levels ]
#
#  Output: the location and average level of each protein
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

# Get all the protein (keys of %protData)
my @proteins = keys %protData;

# Get for each protein its location and print it out
foreach my $protName (@proteins) {
	my $protLocation = $protData{$protName}{"location"};
	print "The location of $protName is: $protLocation\n";
	
	# Compute average of levels and print it
	my @levelArr = @{$protData{$protName}{"levels"}};
	my $sum = 0;
	foreach my $level (@levelArr) {
		$sum = $sum + $level;
	}
	my $avr = $sum / scalar (@levelArr);
	print "The average level of $protName is: $avr\n\n";
	
}

# Close input file
close(IN);