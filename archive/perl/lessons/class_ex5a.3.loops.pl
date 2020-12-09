use strict;

# open file
open (IN, "<fight club.txt")  or die "cannot open fight club.txt";
# read all lines
my @lines = <IN>;
chomp @lines;

#pass on each line and print the number 'i' in each line
foreach my $line (@lines) {
	my $iCounter = 0;		# Reset counter of the number of 'i' in the line. 

	# split line to characters and count number of 'i'.
	my @splitted = split (//,$line);
	foreach my $char (@splitted) {
		if ($char eq 'i'){
			$iCounter++;
		}
	} 
	#print the count of 'i'
	print "$iCounter\n";
}

# close file
close (IN); 
