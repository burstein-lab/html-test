use strict;

print "Enter numbers separated by spaces.\n";
my $sum = 0;
my $line = <STDIN>;
chomp $line;
my @numbers = split(/ /,$line);
foreach my $number (@numbers){
	$sum += $number;
}
print "The sum is $sum\n";