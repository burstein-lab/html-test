use strict;

##########################################################################################################
#    Write the following regular expressions substitutions.
#    For each string print it before the substitution and after it.
#    2) Replace every digit in the line with a #, and print the result.
##########################################################################################################

print "please enter a line\n";
my $line = <STDIN>;
chomp($line);
print "The original sequence : $line\n";
if($line =~ s/\d/#/g){
	print "After the substitution: $line\n";
}
else{
	print "No change was made...\n";	
}