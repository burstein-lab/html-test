use strict;
######################################
# Purpose: Extract paper titles from a Genbank genomic record and store in a hash by the authors' names
#          then ask for an author name and print the title
# Parameters: Input genbank file name
#

# Open input file
if (scalar(@ARGV) < 1) {die "USAGE: class_ex.pl INPUT_FILE\n";}
open (IN, $ARGV[0]) or die "Can't open file '$ARGV[0]'\n";

# Go over all lines, search for author names and paper titles,
# and insert into a hash
my %authorTitle;
while (my $line = <IN>) {
	chomp $line;

	# Find AUTHORS lines, for example:
	#  AUTHORS   Davison,A.J., Benko,M. and Harrach,B.
	#  AUTHORS   Sprengel,J., Schmitz,B., Heuss-Neitzel,D., Zock,C. and Doerfler,W.
	# and then read the title line that follows
	if ($line =~ m/^\s*AUTHORS\s+(.*)/) {
		my $authorsLine = $1;
		# See if there are more names on the next line, until we reach the TITLE line
		$line = <IN>;
		chomp $line;
		while ($line !~ m/^\s*TITLE/) {
			$line =~ s/^\s+/ /;  # Remove spaces in the beginning of the line
			$authorsLine = $authorsLine . $line;
			$line = <IN>;
			chomp $line;
		}
		# Get rid of the word AUTHORS
		$authorsLine =~ s/^\s*AUTHORS\s+//;
		# Separate last names and get rid of the commas and one or more initials
		my @authors = split(/, | and /, $authorsLine);
		# Remove commas and initials
		for(my $i=0; $i<scalar(@authors); $i++) {
			$authors[$i] =~ s/,.*//;
		}

		# read TITLE line
		$line =~ m/^\s*TITLE\s+(.+)/;
		my $title = $1;
		# See if the title continues on the next line, until we reach the JOURNAL line
		$line = <IN>;
		chomp $line;
		while ($line !~ m/^\s*JOURNAL/) {
			$line =~ s/^\s+/ /;  # Remove extra spaces in the beginning of the line
			$title = $title . $line;
			$line = <IN>;
			chomp $line;
		}

		# Insert the title into the hash with each of the names as a key
		foreach my $author (@authors) {
			$authorTitle{$author} = $title;
		}
	}
}

print "Enter author last name:\n";
my $author = <STDIN>;
chomp $author;
if (exists $authorTitle{$author}) {
	print "TITLE: $authorTitle{$author}\n";
} else {
	print "Author name was not found\n";
}
