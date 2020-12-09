use strict;
#####################################################
# Parameters: input Blast file name
# Output: % identity of each HSP of the first hit of each query
#####################################################
use Bio::SearchIO;

if ( scalar(@ARGV) < 1 ) { die "USAGE: $0 INPUT_FILE\n"; }
my ($blastFile) = @ARGV;
my ( $queryName, $hitName, $evalue, $id, $queryHashRef );

  # Open blast file
  my $blast_report = new Bio::SearchIO ( "-format" => "blast",
										 "-file"   => "<$blastFile" );

my %blastHash;

# Pass through every query
while ( my $resultObj = $blast_report->next_result ) {
	                                                      # Get quey name
	$queryName = $resultObj->query_name();

	# Get first hit
	my $hitObj = $resultObj->next_hit();
	if ( defined $hitObj ) {

		# Get hit name
		$hitName = $hitObj->name();

		# Get first HSP
		my $hspObj = $hitObj->next_hsp();

		# Get % id and e-value of HSP
		$id     = $hspObj->percent_identity();
		$evalue = $hspObj->evalue();

	}
	else {
		( $hitName, $id, $evalue ) = ( "", "", "" );
	}

	# Get ref to annonymous hash and insert to main hash
	$queryHashRef = { "hit"    => $hitName,
					  "id"     => $id,
		   			  "evalue" => $evalue	};

	$blastHash{$queryName} = $queryHashRef;
}

# Print the whole thing
foreach $queryName (keys %blastHash){
	print "Query: $queryName\n";
	my $innerHashRef = $blastHash{$queryName};
	print "\t First hit :". $innerHashRef->{"hit"}."\n";
	print "\t % identity:". $innerHashRef->{"id"}."\n";
	print "\t e-value   :". $innerHashRef->{"evalue"}."\n";
}

