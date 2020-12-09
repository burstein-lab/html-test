use strict;

#####################################################
# Purpose: Store info from FASTA header in a data structure
# Input: A FASTA file with header line of the following format:
# >accession #DE description #LN length #CD coding sequence start..end #TA TATA-box #PA poly-A start #RP repetitive element start..end
#
# The fields of #PA, #TA and #RP are optional (some sequences won†¢t have them), and #RP may appear more than once, but always at the end of the line. 
#
# The data structure used is:
# $mrna { $accession }->{'seq'} 		= $seq
#					  ->{'description'} = $description
#					  ->{'length'} 		= $length
#					  ->{'cds'}			= [$cdsStart, $cdsEnd]
#					  ->{'tata'} 		= $tata
#					  ->{'polyA'} 		= $polyA
#					  ->{'repElements'} = [ [$repElementStart1..$repElementEnd1],
#											[$repElementStart2..$repElementEnd2],
#										  										 ...]
#####################################################

# open input file
if (scalar(@ARGV) < 1) {die "Missing input file\n";}
my ($inFileName) = @ARGV;
open (IN, "<$inFileName") or die "can't open '$inFileName'";

###################################
# 1. Foreach sequene in the input #
###################################
my (@lines, $line, $header, $seq);
my %mrna;  # Data structure
my $numSeq = 0;
$line = <IN>;
chomp $line;

while (defined($line)) {
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
			last;
		}
		chomp $line;
	}
	
	################################
	# 2. Parse info from header line

	# Split the header line into data fields by the "#XX" annotations
	my @fields = split('#', $header);
	my $accession = shift @fields;

	my ($description, $length, @cds, $tata, $polyA, @repElements);
	foreach my $field (@fields) {
		# Handle each field type
		if ($field =~ m/^DE\s+(.*)/) {
			$description = $1;
		} elsif ($field =~ m/^LN\s+(\d+)/) {
			$length = $1;
		} elsif ($field =~ m/^CD\s+(\d+)..(\d+)/) {
			@cds = ($1,$2);
		} elsif ($field =~ m/^TA\s+(\d+)/) {
			$tata = $1;
		} elsif ($field =~ m/^PA\s+(\d+)/) {
			$polyA = $1;
		} elsif ($field =~ m/^RP\s+(\d+)..(\d+)/) {
			my @repElement = ($1,$2);
			push (@repElements, [@repElement]);
		} else { die "Unrecognized field '$field' in line: $line\n"; }
	}

	################################
	# 3. Store all info in the data structure
	$mrna{$accession}->{'seq'} 			= $seq;
	$mrna{$accession}->{'description'} 	= $description;
	$mrna{$accession}->{'length'} 		= $length;
	$mrna{$accession}->{'cds'} = [@cds];
	$mrna{$accession}->{'tata'} = $tata;
	$mrna{$accession}->{'polyA'} = $polyA;
	$mrna{$accession}->{'repElements'} = [@repElements];
	$numSeq++;
}
print "Read $numSeq sequences\n";


# Quesion 5b: Print the DEscription of all sequences with a TAta box
foreach my $accession (keys %mrna) {
	if (defined $mrna{$accession}->{'tata'}) {
		print "This protein have a TATA box: $mrna{$accession}->{'description'}\n";
	}
}
print "=====================================\n"; 

# Quesion 5c: Ask the user for a length and print all accessions of sequences shorter than that length
print "Enter a maximum length:\n";
my $maxLength = <STDIN>;
chomp $maxLength;
print "These are longer than $maxLength bp:\n"; 
foreach my $accession (keys %mrna) {
	if ($mrna{$accession}->{'length'} < $maxLength) {
		print "$accession: $mrna{$accession}->{'length'}\n";
	}
}
print "=====================================\n"; 

# Quesion 5d: Print the lengths of the proteins coded by the mRNAs (number of amino acids), and add  a note for every protein with two or more RPs
print "\nLengths of coded proteins:\n";
foreach my $accession (keys %mrna) {
	my $cdsLength = $mrna{$accession}->{'cds'}->[1] - $mrna{$accession}->{'cds'}->[0] + 1;
	my $proteinLength = $cdsLength / 3;
	print "$accession: $proteinLength\n";
	my $nRepElements = scalar @{ $mrna{$accession}->{'repElements'} };
	if ( $nRepElements > 2){
		print "Note: this protein contains $nRepElements repetative elements...\n"
	} 
}
print "=====================================\n"; 

# Quesion 5e: Ask the user for a phrase and print all accessions of sequences whose description contains that phrase
print "\nEnter a phrase:\n";
my $phrase = <STDIN>;
chomp $phrase;
foreach my $accession (keys %mrna) {
	if ($mrna{$accession}{"description"} =~ m/$phrase/) {
		print "$accession: $mrna{$accession}{'description'}\n";
	}
}
print "=====================================\n"; 

# Close input file
close(IN);