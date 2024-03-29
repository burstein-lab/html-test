use strict;
######################################
# Get from the user a DNA sequence and change it to a RNA sequence (change every T to U).


# Get from the user a DNA sequence
print "Type the DNA sequence...\n";

my $seqDNA = <STDIN>;
chomp($seqDNA);

# change every A and G to U and every C and T to Y.
$seqDNA =~ tr/AG/UU/;
my $countChanges = ($seqDNA =~ tr/CT/YY/);
print "The changed seq:\n$seqDNA \n";
print "Number of pyrimidines: $countChanges\n";
