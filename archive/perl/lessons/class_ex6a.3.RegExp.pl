use strict;

##########################################################################################################
#    Write the following regular expressions.  
#    Test them with a script that reads a line from STDIN and prints "yes" if it matches and "no" if not.
#    3) Match an NLS that start with K followed by K or R followed by any character except D or E, 
#       followed by either K or R. Match either small or capital letters 
##########################################################################################################

print "please enter a squence suspected to contain an NLS...\n";
my $line = <STDIN>;
chomp($line);

if($line =~ m/K[RK][^ED][RK]/i){
	print "yes\n";
}
else{
	print "no\n";	
}