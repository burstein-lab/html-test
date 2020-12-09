use strict;

##########################################################################################################
#    Write the following regular expressions substitutions.
#    For each string print it before the substitution and after it.
#    1) Replace every T to U in a DNA sequence.
##########################################################################################################

print "please enter a DNA sequence\n";
my $line = <STDIN>;
chomp($line);
print "The original sequence : $line\n";
if($line =~ s/T/U/gi){
	print "After the substitution: $line\n";
}
else{
	print "No change was made...\n";	
}