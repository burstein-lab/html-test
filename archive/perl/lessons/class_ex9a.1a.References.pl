###########################################################
# Purpose: Store levels of proteins in array within a hash
#
# $protLevels{ $protName } = [ @levels ]
#
# Output: sorted levels array of the protein entered by user
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

# Ask user for protein 
print "Which protein are you interested in?\n";
my $userProt = <STDIN>;
chomp $userProt;
# check that indeed inserted protein exist in the hash
# if so - print sorted array of levels
if (exists $protLevels{$userProt}) {
	my @sortedLevels = sort( @{$protLevels{$userProt}} );
	print "The (sorted) protein levels of $userProt are:\n";
	print "@sortedLevels\n";
}
else {
	print "Sorry could not find this protein...\n";
}

# Close input file
close(IN);