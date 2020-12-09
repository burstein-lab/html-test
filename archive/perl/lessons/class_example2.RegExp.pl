use strict;

open(IN, "<numbers.txt") or die "cannot open numbers.txt";
my $line = <IN>;
while (defined $line) {
	if($line =~ m/-?\d+/){
		print "This line seems to contain a number...\n";
	}
	else{
		print "This is certainly not a number...\n";	
	}
	$line = <IN>;
}