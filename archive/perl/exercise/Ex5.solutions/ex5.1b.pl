###########################################################
# Purpose: Read FASTA headers and store in a hash the 
# information of the gi number and the sequence:
#
# $fasta{ $gi } = $seq
#
# Output: full protein sequence of gi entered by user.
#############################################################

use strict;

# Open and read input file
if (scalar(@ARGV) < 1) {die "Fasta file missing\n";}
my ($inFile) = @ARGV;
open(IN,"<$inFile") or die "Can't open file $inFile\n";

# read header and sequence
my (%fasta,$header, $gi, $seq);
my $fastaLine = <IN>;
while (defined $fastaLine) {
	
	# reaed first gi of first header	
	chomp $fastaLine;
	$header = substr($fastaLine,1);
	if ($header =~ m/gi\|(\d+)\|/) {
		$gi = $1;
	}
	
	## Read seq until next header
	$fastaLine = <IN>;
	$seq = "";
	while ((defined $fastaLine) and
		  (substr($fastaLine,0,1) ne ">" )) {
		chomp $fastaLine;
		$seq = $seq.$fastaLine;
		$fastaLine = <IN>;
	}
	## insert into hash $gi as key and $seq as value
	$fasta{$gi} = $seq;
}

# Ask user for a gi number 
print "Which gi are you interested in?\n";
my $userGi = <STDIN>;
chomp $userGi;
# check that indeed gi number exist in the hash
# if so - print sequence
if (exists $fasta{$userGi}) {
	my $userSeq = $fasta{$userGi};
	print "The sequence of GI $userGi is:\n";
	print "$userSeq\n";
}
else {
	print "Sorry could not find this gi number...\n";
}

# Close input file
close(IN);