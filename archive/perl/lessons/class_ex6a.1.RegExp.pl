use strict;

##########################################################################################################
#    Write the following regular expressions.  
#    Test them with a script that reads a line from STDIN and prints "yes" if it matches and "no" if not.
#    1)Match a name containing a capital letter followed by three lower case letters
##########################################################################################################

print "please enter a name...\n";
my $line = <STDIN>;
chomp($line);

if($line =~ m/[A-Z][a-z]{3}/){
	print "yes\n";
}
else{
	print "no\n";	
}