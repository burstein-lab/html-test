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

my $isReferenceWithAuFound = 0;
my $isAuLines = 0;

my @lines = <IN>;
foreach my $line (@lines) {
	chomp $line;
	if($line =~ m/^\s*REFERENCE/){
		$isReferenceWithAuFound = 0;    # for each referece initialize back to 0		
	}	
	if($line =~ m/AUTHORS/){
		$isAuLines = 1;	# The start of authors lines
	}
	if($line =~ m/TITLE/){
		$isAuLines = 0;	# The end of authors lines
	}						
	if ($isAuLines and $line =~ m/$lastNameAu,$firstLetterOffirstNameAu/ ) {
		$isReferenceWithAuFound = 1;
	}		
	if ( $isReferenceWithAuFound and ( $line =~ m/^\s*JOURNAL.*.*\D(\d+-\d+).*\((\d+)\)/ ) )	{
		print "$2\n";
	}
}
close(IN);
