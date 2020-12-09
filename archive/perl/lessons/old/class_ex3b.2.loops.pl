use strict;

print "Enter protein sequences in FASTA format\n";
my $line;
my @fastaLines = <STDIN>;
foreach $line (@fastaLines) {
	if (substr($line,0,1) eq ">") {
		print(substr($line,1));
	}
}