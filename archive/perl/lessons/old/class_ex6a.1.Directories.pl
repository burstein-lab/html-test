use strict;

#####################################################
# Write a script that prints all the file in your directory, 
# which their names  end with .pl, to a file named "perlFiles.txt".
#####################################################
my $dirName = "C:\\Perl\\lib";
my $outFileName = "C:\\eclipse\\perl_ex\\perlFiles.txt";

open(OUT, ">$outFileName") or die "can't open file $outFileName";

my @files = <$dirName\\*.pl>;
foreach my $fileName (@files){
	print OUT "$fileName\n";
}

close(OUT);
