use strict;
#####################################################
# Parameters: input Blast file name
# Output: % identity of each HSP of the first hit of each query
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

	# Get first hit  
	my $hitObj = $resultObj->next_hit();
	if (defined $hitObj){
		
		# Pass through every HSP of first hit and print e-value
		my $i = 1;
		my $hspObj = $hitObj->next_hsp();
		while (defined $hspObj)	{
			print "The e-value of HSP no. ".$i." is: ".$hspObj->evalue()."\n";
			$i++;
			$hspObj = $hitObj->next_hsp();
		}
		print "\n";
	} else {
		print "No hits found...\n\n"	
	}
}
	