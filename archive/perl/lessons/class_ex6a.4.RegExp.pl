use strict;

##########################################################################################################
#    Write the following regular expressions.  
#    Test them with a script that reads a line from STDIN and prints "yes" if it matches and "no" if not.
#    4) Match 3 - 15 characters between quotes (without another quote inside the quotes)
##########################################################################################################

print "please enter a line\n";
my $line = <STDIN>;
chomp($line);

if($line =~ m/"[^"]{3,15}"/){
	print "yes\n";
}
else{
	print "no\n";	
}