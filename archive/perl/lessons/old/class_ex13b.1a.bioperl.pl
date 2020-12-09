use strict;
#####################################################
# Parameters: input Blast file name
# Output: each query name and the name of its first hit
#####################################################
use Bio::SearchIO;

if ( scalar(@ARGV) < 1 ) { die "USAGE: $0 INPUT_FILE\n"; }
my ($blastFile) = @ARGV;

# Open blast file
my $blast_report = new Bio::SearchIO(	"-format" => "blast",
										"-file"   => "<$blastFile");

# Pass through every query
while ( my $resultObj = $blast_report->next_result ) {
	print "Query: ".$resultObj->query_name(). "\n";

	# Get first hit and print its name
	my $hitObj = $resultObj->next_hit();
	if (defined $hitObj){
		print "First hit: ".$hitObj->name()."\n\n";
	} else {
		print "No hits found...\n\n"	
	}
}
	