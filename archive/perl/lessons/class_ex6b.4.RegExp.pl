use strict;

##########################################################################################################
#    Write the following regular expressions substitutions.
#    For each string print it before the substitution and after it.
#    4) Remove all such appearances of "is" from the line (both small and capital letters), and print it.
##########################################################################################################

print "please enter a line\n";
my $line = <STDIN>;
chomp($line);
print "The original sequence : $line\n";
if($line =~ s/is//g){
	print "After the substitution: $line\n";
}
else{
	print "No change was made...\n";	
}