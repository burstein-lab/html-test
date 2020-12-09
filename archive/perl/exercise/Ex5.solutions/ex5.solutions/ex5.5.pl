use strict;

#####################################################
# Purpose: Store info from FASTA header in a data structure
# Input: A FASTA file with header line of the following format:
# >accession #DE description #LN length #CD coding sequence start..end #TA TATA-box #PA poly-A start #RP repetitive element start..end
#
# The fields of #PA, #TA and #RP are optional (some sequences won†¢t have them), and #RP may appear more than once, but always at the end of the line. 
#
# The data structure used is:
# %mrna {$accession}  => { 'seq' => $seq,
#						 			'description' => $description,
#						 			'length' => $length,
#						 			'cds' => [$cdsStart, $cdsEnd],
#						 			'tata' => $tata,
#						 			'polyA' => $polyA,
#						 			'repElements' => [[$repElementStart1..$repElementEnd1],
#														   [$repElementStart2..$repElementEnd2],
#										  																 ...]
#						 }
#####################################################

# open input file
if (scalar(@ARGV) != 1) {die "USAGE: $0 INPUT_FILE\n";}
my ($inFileName) = @ARGV;
open (IN, "<$inFileName") or die "can't open '$inFileName'";

###################################
# 1. Foreach sequene in the input #
###################################
my (@lines, $line, $header, $seq);
my $endOfInput = 0;
my %mrna;  # Data structure
my $numSeq = 0;
$line = <IN>;
chomp $line;

while ($endOfInput==0) {
	################################
	# 1. Read a sequence
	# 1.1. Read sequence name from FASTA header line
	# Here I assume that the header line was read into $line
	if (substr($line,0,1) eq ">") {
		$header = substr($line,1);
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
	# 2. Parse info from header line

	# Split the header line into data fields by the "#XX" annotations
	my @fields = split('#', $header);
	my $accession = shift @fields;

	my ($description, $length, $cdsStart, $cdsEnd, $tata, $polyA, @repElements);
	foreach my $field (@fields) {
		# Handle each field type
		if ($field =~ m/^DE\s+(.*)/) {
			$description = $1;
		} elsif ($field =~ m/^LN\s+(\d+)/) {
			$length = $1;
		} elsif ($field =~ m/^CD\s+(\d+)..(\d+)/) {
			$cdsStart = $1;
			$cdsEnd = $2;
		} elsif ($field =~ m/^TA\s+(\d+)/) {
			$tata = $1;
		} elsif ($field =~ m/^PA\s+(\d+)/) {
			$polyA = $1;
		} elsif ($field =~ m/^RP\s+(\d+)..(\d+)/) {
			my @repElement = ($1,$2);
			push @repElements, \@repElement;
		} else { die "Unrecognized field '$field' in line: $line\n"; }
	}

	################################
	# 3. Store all info in the data structure
	$mrna{$accession} = {'seq' => $seq,
						 'description' => $description,
						 'length' => $length,
						 'cds' => [$cdsStart, $cdsEnd],
						 'tata' => $tata,
						 'polyA' => $polyA,
						 'repElements' => \@repElements,
						 };
	$numSeq++;
}
print "Read $numSeq sequences\n";

# Quesion 5b: Ask the user for a length and print all accessions of sequences shorter than that length
print "Enter a maximum length:\n";
my $maxLength = <STDIN>;
chomp $maxLength;
foreach my $accession (keys %mrna) {
	if ($mrna{$accession}{"length"} < $maxLength) {
		print "$accession: $mrna{$accession}{'length'}\n";
	}
}

# Quesion 5c: Print the lengths of the proteins coded by the mRNAs (number of amino acids), and add  a note for every protein with two or more RPs
print "\nLengths of coded proteins:\n";
foreach my $accession (keys %mrna) {
	my $cdsLength = $mrna{$accession}{"cds"}[1] - $mrna{$accession}{"cds"}[0] + 1;
	my $proteinLength = $cdsLength / 3;
	print "$accession: $proteinLength\n";
}

# Quesion 5d: Ask the user for a phrase and print all accessions of sequences whose description contains that phrase
print "\nEnter a phrase:\n";
my $phrase = <STDIN>;
chomp $phrase;
foreach my $accession (keys %mrna) {
	if ($mrna{$accession}{"description"} =~ m/$phrase/) {
		print "$accession: $mrna{$accession}{'description'}\n";
	}
}
