###########################################################
# Purpose: Store levels of proteins in array within a hash
# Get protein an measurement from user and add it to the hash
#
# $protLevels{ $protName } = [ @levels ]
#
# Output: Print updated levels of this protein
#############################################################


use strict;

# Open and read input file
open(IN,"<proteinLevels.txt") or die "Can't open file proteinLevels.txt\n";
my @protLines = <IN>;
chomp @protLines;

# read each line, and had to protein hash
my %protLevels;
foreach my $line (@protLines){
	# check line in correct format and extract name and levels. Such as:
	# AP_000155	0.96,0.20,0.50
	if ($line =~ m/(\w+)\s+(\S+)/){
		my $protName = $1;
		my @levels = split(/,/,$2);				
		# insert levels to hash with protein name as a key
		$protLevels{$protName} = [@levels];
	}	
}

# Ask user for protein and and new measurment
print "Which protein you wish to update?\n";
my $userProt = <STDIN>;
chomp $userProt;
print "What is the new protein level that should be added?\n";
my $userLevel = <STDIN>;
chomp $userLevel;

# Push new measurment to protein
push(@{$protLevels{$userProt}},$userLevel);

# Print updated array of levels
my @levelArr = @{$protLevels{$userProt}};
print "The protein levels of $userProt are:\n";
print "@levelArr\n";

# Close input file
close(IN);