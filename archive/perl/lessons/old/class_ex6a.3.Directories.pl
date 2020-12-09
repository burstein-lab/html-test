use strict;

#####################################################
# Write a script that prints all the file in your directory, 
# which their names  end with .pl, to a file named "perlFiles.txt".
# Change the script of the previous question, such that the directory name and the output file are passed as command-line arguments.
# Change the previous script, such that after creating the output file, it is copied to another file, whose name is also passed as a command-line argument.
#####################################################

if (@ARGV < 3) {
	print '# Please provide parameters by:',"\n";
	print '$dirName,$outFileName, $outFileNameCopy',"\n";
		die "USAGE: $0: not enough parametrs"; 
}

my ($dirName,$outFileName, $outFileNameCopy) = @ARGV;


open(OUT, ">$outFileName") or die "can't open file $outFileName";
my @files = <$dirName\\*.pl>;
foreach my $fileName (@files){
	print OUT "$fileName\n";
}
close(OUT);

my $systemReturn = system("copy $outFileName $outFileNameCopy");
if ($systemReturn != 0) { 
	die "can't copy $outFileName\n"; 
}



