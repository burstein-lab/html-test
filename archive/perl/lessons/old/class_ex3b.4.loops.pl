use strict;

print "Enter a number on each line, and terminate with END\n";
my @name;
my @nameArr;
my $fullName = <STDIN>;
chomp $fullName;
while ($fullName ne 'END'){
	@name = split(/ /,$fullName);
	push (@nameArr, $name[1]);
	$fullName = <STDIN>;
	chomp $fullName;
}
@nameArr = sort (@nameArr);
print "@nameArr";