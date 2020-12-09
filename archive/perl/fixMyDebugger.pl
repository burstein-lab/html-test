use strict;
use File::Copy;

# Set default file location
my $perlDir = 'C:\Perl';
my @altPerlDirArr = ('D:\Perl','C:\Perl64','D:\Perl64');
my $cwdLocation= 'lib\Cwd.pm';
my $cwdFile = "$perlDir\\$cwdLocation"; 
my $i=0;
# If not in C:\Perl - try in D:\Perl or C:\Perl64 or D:\Perl64
while (not -e "$cwdFile" && $i <= $#altPerlDirArr) {
	$perlDir = $altPerlDirArr[$i];
	$cwdFile = "$perlDir\\$cwdLocation";
	$i++;
}

# If not in D:\Perl - ask user where did he install Perl
if ($i > $#altPerlDirArr) {
	print "Sorry - I can't seem to find you Perl installation...\n"; 
	print "Please type your installation directore (for example: $perlDir)\n";
	$perlDir = <STDIN>;
	$cwdFile = "$perlDir\\$cwdLocation";
}

# If still not found - honorly give up
if (not -e "$cwdFile") {
	die "Sorry - still can't find Perl directory. Try again or contact your instructor\n"; 
}

# open Cwd file for reading and tmp file for writing 
my $tmpFile = "$cwdFile.tmp";
my $oldFile = "$cwdFile.__old";

open(CWD,"<$cwdFile") or die "cannot open $cwdFile";
open(TMP,">$cwdFile.tmp");

# Go through each line of Cwd file and write it to temp file (modify only necessary line)
print "OK. Let's do some fixin'....\n";
my $cwdLine = <CWD>;
my $fix = 0;
while (defined $cwdLine) {
	# find evil line and fix it!
	if ($cwdLine =~ m/if \(eval 'defined &DynaLoader::boot_DynaLoader'\)/){
		print "Changed:\n".$cwdLine; 
		$cwdLine =~ s/(.*)eval '(.*)'(.*)/$1$2$3/;
		$fix++;
		print "To:\n".$cwdLine; 
	}
	#write every line (including fixed one) to tmp file
	print TMP $cwdLine;
	$cwdLine = <CWD>;
}

# close files
close (CWD);
close (TMP);

# report conclusions
print "\nReinstalling padwalker (just in case), please wait it might take a few minutes...\n";
print `ppm install http://www.bribes.org/perl/ppm/PadWalker.ppd`;
if ($fix > 0){
	if (not -e $oldFile) {
		copy($cwdFile, $oldFile);
	}
	unlink $cwdFile;	
	copy($tmpFile, $cwdFile);
	print "\nSeems that the file was fixed. Please try to debug again.\n";
	print "(You might need to restart eclipse before it works).\n";
	print "Have a nice day\n= )\n";
} else {
	print "\nTry to restart eclipse and debug again.\n";
	print "If you still cannot debug - conact your instructor.\n";
	unlink $tmpFile;
}
