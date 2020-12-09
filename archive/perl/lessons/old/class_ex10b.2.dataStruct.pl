use strict;
######################################
# Purpose: Extract gene annotations from a Genbank genomic
#          record and store in a complex data structure
# Parameters: Input file name
#

# open input file
if (scalar(@ARGV) != 1) {die "USAGE: class_ex.pl INPUT_FILE\n";}
my $inFile = $ARGV[0];
open IN, $inFile or die "Can't open file '$inFile'\n";

######################################
# Read file and store gene data in a hashes of gene records
#
my $CDSs = 0;
my %genes;
my ($line, $name, $proteinId, $strand, $start, $end);
$line = <IN>;
while (defined($line)) {
	chomp $line;

	# Identify the first line about a gene - the "CDS" line
	# Extract coding sequences.	e.g.   CDS          3374..3808
	if ($line =~ m/^\s*CDS\s+(complement\()?(join\()?<?(\d+).+\.(\d+)>?\){0,2}\s*$/) {
		$CDSs++;
		
		# Get start and end of exon
		($start,$end) = ($3,$4);
		# Get strand information
		if (defined($1)) {
			$strand = "-";
		} else {
			$strand = "+";
		}

		# Find "product" and "protein_id" lines
		while (defined($line = <IN>) && $line !~ m/^\s*CDS\s/) {
			# Extract product name.		e.g.   /product="IVa2"
			if ($line =~ m/^\s*\/product="(.+)"/) {
				$name = $1;
			}
			# Extract protein IDs.		e.g.   /protein_id="AP_000116.1"
			if ($line =~ m/^\s*\/protein_id="(\S+)"/) {
				$proteinId = $1;
			}
		}
		if (!defined($name)) { die "No 'product' annotation for CDS starting at $start"; }
		if (!defined($proteinId)) { die "No 'protein_id' annotation for CDS starting at $start"; }

		# Enter data into %genes
		$genes{$name} = {"protein_id" => $proteinId,
						 "strand" => $strand};

	} else {
		# Check that the reg-exp didn't miss a "CDS" line
		if ($line =~ m/^\s*CDS/) { die "It looks like we missed a \"CDS\" line: '$line'"; }
		$line = <IN>;
	}
}

print "Found $CDSs CDSs\n";
print "Number of gene records: " . scalar(keys(%genes)) . "\n";

######################################
# Print names of genes that fit certain criteria
#
foreach $name (sort(keys(%genes))) {
	if ($genes{$name}{"strand"} eq "-")
	{
		print "<-- $name - Antisense gene ($genes{$name}{strand})\n";
	}
}
