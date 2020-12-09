use strict;

#####################################################
# Purpose: Store lists of measurements in a hash
# Input: A file containing an sample number and a list of measurements on each line:
# 104	0.4904	0.3992	0.4832
# 111	0.4322	0.3932	0.4355
# 122	0.4243	0.3203	0.4342
# Then ask for a sample number and print the list of measurements
#####################################################

# open input file
if (scalar(@ARGV) < 1) {die "USAGE: $0 INPUT_FILE\n";}
my ($inFileName) = @ARGV;
open (IN, "<$inFileName") or die "can't open '$inFileName'";

my ($line, @idAndMeasurements, $id, $measurement);
my %measurements;

# A loop to process one input line at a time and print the output for that line
foreach $line (<IN>) {
	chomp $line;

	# Separate id and numbers
	@idAndMeasurements = split(/\s+/, $line);
	$id = shift @idAndMeasurements;
	#my @measurements = @idAndMeasurements;  # Create a new variable every iteration

	$measurements{$id} = [@idAndMeasurements];
}

# Ask for a sample number and print the sum of measurements
print "Enter a sample number:\n";
$id = <STDIN>;
chomp $id;
if (exists $measurements{$id}) {
	print join("\t", @{$measurements{$id}}), "\n";
} else {
	print "No such sample number\n";
}
