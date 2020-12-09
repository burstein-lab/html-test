use strict;

##########################################################################################################
#    Write the following regular expressions.  
#    Test them with a script that reads a line from STDIN and prints "yes" if it matches and "no" if not.
#    2) Match an NLS (nuclear localization signal) that start with K followed by K or R followed by any 
#       character followed by either K or R. 
##########################################################################################################

print "please enter a squence suspected to contain an NLS...\n";
my $line = <STDIN>;
chomp($line);

if($line =~ m/K[RK].[RK]/){
	print "yes\n";
}
else{
	print "no\n";	
}