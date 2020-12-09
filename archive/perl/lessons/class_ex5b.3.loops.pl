use strict;

# open file
my ($inFile) = @ARGV;
open (IN, "<$inFile") or die "cannot open $inFile";

## 1.1. Read name and save it
my $line = <IN>;
while (defined $line) {
	chomp $line;
	my $name = $line;
	## 1.2. Read amounts until next name
	$line = <IN>;
	my $sum = 0;	# reset sum
	while ((defined $line) and
		  (substr($line,0,1) eq "+" )) {
		chomp $line;
		my $num = substr($line,1);
		$sum = $sum + $num;
		$line = <IN>;
	}
	## 2.1 print name and sum
	print "$name: $sum\n";
}





# close file
close (IN); 
