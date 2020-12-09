use strict;
######################################
# Get the first and last names of an author from the user,
# find the paper in the adenovirus record and print the year of publication.

if ( scalar(@ARGV) != 1 ) { die "USAGE: class_ex.pl INPUT_FILE\n"; }
my ($inFile) = @ARGV;

# Get first and last name of an author
print "Type the first name of an author (or the first letter of his first name)...\n";
my $firstNameAu = <STDIN>;
chomp($firstNameAu);
my $firstLetterOffirstNameAu = substr( $firstNameAu, 0, 1 );

print "Type the last name of an author...\n";
my $lastNameAu = <STDIN>;
chomp($lastNameAu);

# open input file
open (IN, "<$inFile") or die "Can't open file '$inFile'\n";
my $line = <IN>;

while ( defined $line ) { # loop 1 - over all lines in file
	chomp $line;

	my $isReferenceWithAuFound = 0;    # In each referece initialize back to 0
	while ( ( defined $line ) and !( $line =~ m/^\s*REFERENCE/ ) ) { # loop 2 - within a given reference
		chomp $line;
		if($line =~ m/AUTHORS/){	# loop 3 - AUTHORS lines
			while ( (defined $line) and !( $line =~ m/^\s*TITLE/) ){
				if ( $line =~ m/$lastNameAu,$firstLetterOffirstNameAu/ ) {
					$isReferenceWithAuFound = 1;
				}
				$line = <IN>;
				chomp $line;					
			}				
		}
		if ( $isReferenceWithAuFound and ( $line =~ m/^\s*JOURNAL.*.*\D(\d+-\d+).*\((\d+)\)/ ) )	{
			print "$2\n";
		}
		$line = <IN>;
	}

	$line = <IN>;
}
close(IN);
