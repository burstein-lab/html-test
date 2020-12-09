use strict;

print "please enter a line...\n";
my $line = <STDIN>;
chomp($line);

if($line =~ m/-?\d+/){
	print "This line seems to contain a number...\n";
}
else{
	print "This is certainly not a number...\n";	
}