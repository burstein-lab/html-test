use strict;

#####################################################
# Write a script that prints all the file in your directory, 
# which their names  end with .pl, to a file named "perlFiles.txt".
# Now, Change the script of the previous question, such that the directory name and the output file are passed as command-line arguments.
#####################################################

if (@ARGV < 2) {
	print '# Please provide parameters by:',"\n";
	print '($dirName,$outFileName) = @ARGV',"\n";
		die "USAGE: $0: not enough parametrs"; 
}

my ($dirName,$outFileName) = @ARGV;





open(OUT, ">$outFileName") or die "can't open file $outFileName";


my @files = <$dirName\\*.pl>;
foreach my $fileName (@files){
	print OUT "$fileName\n";
}

close(OUT);
