use strict;

##########################################################################################################
#    Write the following regular expressions substitutions.
#    For each string print it before the substitution and after it.
#    3) place any number and kind of white space (new-line, tab or space) by a single space.
##########################################################################################################

print "please enter a line\n";
my $line = <STDIN>;
chomp($line);
print "The original sequence : $line\n";
if($line =~ s/\s+/ /g){
	print "After the substitution: $line\n";
}
else{
	print "No change was made...\n";	
}