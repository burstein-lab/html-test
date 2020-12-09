use strict;

# Ask for a filename from user
print "Please enter a filename:\n";
my $filename = <STDIN>;
chomp $filename;

# check existence
if (-e $filename) {
    print "The file named $filename exists.\n";
} else {
    print "$filename does not exist...\n";
}
