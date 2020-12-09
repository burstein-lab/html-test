use strict;
######################################
# Purpose: Read FASTA file into a hash,
#          then ask for a header line and print the sequence
# Parameters: Name of input file
#

# open input file
if (scalar(@ARGV) < 1) {die "USAGE: $0 INPUT_FILE\n";}
my ($inFileName) = @ARGV;
open (IN, "<$inFileName") or die "can't open '$inFileName'";

###################################
# 1. Foreach sequene in the input #
###################################
my (@lines, $line, $name, $seq);
my $endOfInput = 0;
my %seq;
$line = <IN>;
chomp $line;

while ($endOfInput==0) {
	################################
	# 1. Read a sequence
	# 1.1. Read sequence name from FASTA header line
	# Here I assume that the header line was read into $line
	if (substr($line,0,1) eq ">") {
		$name = substr($line,1);
	} else {
		die "bad FASTA format";
	}

	# 1.2. Read the actual sequence until the next FASTA header
	$seq = "";
	$line = <IN>;
	chomp $line;
	# Read until the next FASTA header or the end of the input
	while (substr($line,0,1) ne ">") {
		$seq = $seq . $line;
		$line = <IN>;
		if (!defined($line)) {
			$endOfInput = 1;
			last;
		}
		chomp $line;
	}

	################################
	# 2. Store in hash
	$seq{$name} = $seq;
}

# Ask for a name and print the sum of expenses
print "Enter a sequence name:\n";
$name = <STDIN>;
chomp $name;
if (exists $seq{$name}) {
	print $seq{$name}, "\n";
} else {
	print "No such name\n";
}
