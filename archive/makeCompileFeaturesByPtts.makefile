#!/usr/bin/gmake -f 

### flags and definitions
# -v  Number of database sequences to show one-line descriptions for (V) [Integer]
# -b  Number of database sequence to show alignments for (B) [Integer]
# -I  Show GI's in deflines [T/F]    
# -e  eVal cutoff
# -FF do not filter low complexity regions (?)
# -a  number of processors to use (!!!!!!!!!!!!!!!!)
BLAST_FLAGS = -p blastp -IT -FF -e0.01 -a24

ECHO = @echo -e
MACHINE = ~/theEffectorMachine/featureCompiler/
SCRIPTS = ~davidbur/scripts/
APPEND = perl -w ~/scripts/horizontalAppendMany.pl ,
SIG_EXT = .-35..faa.psd_cln.info.ge35.lrt
# for tabs instead of , this will do part of the job...
#APPEND = perl -w ~/scripts/horizontalAppendMany.pl "\t"
FORMATDB_FLAGS = -pT
RM = -rm -f -v
EVALUE_THRESHOLD = 0.01

## variables
Dir = $(dir $(ptts))
dataDir = $(Dir)featureData/
blastDir = $(dataDir)blast/
blinkDir = $(dataDir)blink/
strucDir = $(dataDir)struc/

effName = $(subst $(name).,,$(notdir $(eff)))
dataName = $(dataDir)$(name)

pttFiles := $(shell cat $(ptts))
faaFiles =  $(pttFiles:.ptt=.faa)

dbBases = $(basename $(notdir $(databases)))
dbTargets = $(addsuffix .blastp.vals, $(addprefix $(dataDir)$(name).vs.,$(dbBases)))
############################################
#".SECONDARY with no prerequisites causes all targets to be treated as secondary (i.e., no target is removed because it is considered intermediate)."
#.SECONDARY :

### BLASTP template: the parameter $1 is an faa file that is blasted against $(name).faa
define BLASTP_template
$$(blastDir)$$(name).vs.$$(basename $$(notdir $(1))).blastp: $(1).phr $(blastDir)$(name).faa
	$(ECHO)
	$(ECHO) === creating $$@ \(Blasting...\) ===
	blastall $$(BLAST_FLAGS) -i $$(dataName).faa -d $(1) > $$@
endef

# default
All : makeMenu 
#Print a menu of what can be made...
makeMenu :
	$(ECHO) ""
	$(ECHO) "What will you be making today?"
	$(ECHO) "=============================="
	$(ECHO) "make Full      - makes .csv file with all features"
	$(ECHO) "make Shuman    - makes .csv file based on Legionella for new genomes, including HSMM signal, excluding features that are not informative for new genomes (Blink, proximity, etc)."
	$(ECHO) "make Blinkless - makes .csv file will all features, excluding Blink features"
	$(ECHO) "make NoSignals - makes .csv file with all features beside signal features"
	$(ECHO) "make Indie     - makes .csv file only with data independent of effectors list"
	$(ECHO) "make Annot     - makes .csv file only with annotation data"
	$(ECHO) ""
	$(ECHO) "make Blasts   - make only the Blasts (it takes a while)"
	$(ECHO) "make Blink    - prepare only the Blink data (this takes a while as well...)"
	$(ECHO) "make Signal   - prepare only the Signal data"
	$(ECHO) ""
	$(ECHO) "make clean    - delete feature files (EXCEPT blastp files and blink files)"
	$(ECHO) "make cleanCsv - delete only final csv files"
	$(ECHO) "make cleanAll - delete ALL the data created by makefile (you might regret that)"
	$(ECHO) "make help     - print some sort of help file (helpfulness may vary between different users)"
	$(ECHO) ""
	$(ECHO) "* consider using make -j[N]: Allow N jobs at once; infinite jobs with no arg."
	$(ECHO) "* consider using -n --debug OR -n -d for debug info with no action"


# make the csv with everything on it...
Full : Basics $(name).$(effName).csv
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

# make the csv for new genomes
Shuman : Basics $(name).$(effName).Shuman.csv
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

# makes .csv file everything except the Blink info
Blinkless : Basics $(name).$(effName).NoBlink.csv
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

# make the csv file without the regulatory and signal Pssm features
NoSignals : Basics $(name).$(effName).NoSignals.csv
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

# makes .csv file only with data independent of effectors list
Indie : Basics $(dataName).independentFeatures.csv
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

# make the csv file with only annotation data
Annot : makeDirs $(name).$(effName).Annot.csv
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

#cheks that you have the basics
Basics: makeDirs checkParams 
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

# Make the blasts only
Blasts: Basics $(dbTargets)) $(blastDir)$(name).all.vs.all.blastp $(blastDir)
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

# make blink (produces blink data)
Blink : Basics $(dataDir)blink.log $(blinkDir)
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

# make Signal (produces signals data)
Signal : Basics $(dataName).sig
	$(ECHO)
	$(ECHO) ---=== make $@ features: Done! ===--
	$(ECHO)

# for new genomes
$(name).$(effName).Shuman.csv : $(dataName).$(effName).Shuman.csv
	cp $< $@

# make the csv with everything on it...
$(name).$(effName).csv : $(dataName).$(effName).csv
	cp $< $@

# make the csv with everything except Blink...
$(name).$(effName).NoBlink.csv : $(dataName).$(effName).NoBlink.csv 
	cp $< $@

# make the csv file without the regulatory and signal Pssm features
$(name).$(effName).NoSignals.csv : $(dataName).$(effName).NoSignals.csv
	cp $< $@

# Append features dependent and independent of effector list
$(dataName).$(effName).csv : $(dataName).independentFeatures.csv $(dataName).$(effName).dependentFeatures.csv $(dataName).sig $(dataName).HSMM.lrt $(additionals) $(dataName).$(effName).isEff
	$(ECHO)
	$(ECHO) === And now, at last, creating $@ ===
	$(APPEND) $^ > $@

# Append features relevant for Shuman learning (dependent and independent of effector list no blink) no dist with HSMM)
$(dataName).$(effName).Shuman.csv : $(dataName).independentFeatures.NoBlink.csv  $(dataName).$(effName).sim2eff $(dataName).sig $(dataName).HSMM.lrt $(additionals) $(dataName).$(effName).isEff
	$(ECHO)
	$(ECHO) === And now, at last, creating $@ ===
	$(APPEND) $^ > $@


# Append features dependent and independent of effector list (except Blink)
$(dataName).$(effName).NoBlink.csv : $(dataName).independentFeatures.NoBlink.csv $(dataName).$(effName).dependentFeatures.csv $(dataName).sig $(additionals) $(dataName).$(effName).isEff
	$(ECHO)
	$(ECHO) === And now, at last, creating $@ ===
	$(APPEND) $^ > $@


# Append features except pssm related ones
$(dataName).$(effName).NoSignals.csv : $(dataName).independentFeatures.csv $(dataName).$(effName).dependentFeatures.csv $(additionals) $(dataName).$(effName).isEff
	$(ECHO)
	$(ECHO) === And now, creating $@ ===
	$(APPEND) $^ > $@

# Append all features independent of effector list except Blink data
$(dataName).independentFeatures.NoBlink.csv : $(dataName).syn $(dataName).len $(dataName).gc $(dbTargets)
	$(ECHO)
	$(ECHO) === Finally creating $@ ===
	$(APPEND) $^ > $@

# Append all features independent of effector list
$(dataName).independentFeatures.csv : $(dataName).independentFeatures.NoBlink.csv $(dataName).blink 
	$(ECHO)
	$(ECHO) === Finally creating $@ ===
	$(APPEND) $^ > $@

# Append all features dependent of effector list
$(dataName).$(effName).dependentFeatures.csv : $(dataName).$(effName).sim2eff $(dataName).$(effName).dist $(dataName).$(effName).dens $(dataName).$(effName).aaProfile
	$(ECHO)
	$(ECHO) === Finally creating $@ ===
	$(APPEND) $^ > $@

# Append all annotaion data
$(name).$(effName).Annot.csv : $(dataName).syn $(dataName).pid $(dataName).gen $(dataName).len $(dataName).prod 
	$(ECHO)
	$(ECHO) === Finally creating $@ ===
	$(APPEND) $^ > $@

# Get relevent values out of blastp
$(dataDir)%.blastp.vals : $(MACHINE)getBlastAllVsAllInfo.pl $(blastDir)%.blastp
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $^ $(EVALUE_THRESHOLD) -T $(patsubst $(name).vs.%.blastp.vals,%,$(notdir $@)) > $@

### Using BLASTP Template to create blastp dependencies ####
$(foreach database,$(databases),$(eval $(call BLASTP_template,$(database))))
####

# simalrity of ORF to the amino acid content of the effectors
$(dataName).$(effName).aaProfile : $(dataName).$(effName)_aaProfile.pssm  $(dataName).bg.pssm $(dataName).faa
	$(ECHO)
	$(ECHO) === creating $@ ===
	$(MACHINE)/getBestPssmScore.pl $^ -A > $@

# background pssm (amino acids profile of organism) 
$(dataName).bg.pssm : $(dataName).faa
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $(MACHINE)createPssmOfBg.pl $< > $@

# pssm of aa content in effectors 
$(dataName).$(effName)_aaProfile.pssm : $(dataName).$(effName).faa 
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $(MACHINE)createPssmOfBg.pl $< > $@


# gerp fasta subset based on GI
%.faa : %.gi
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $(SCRIPTS)/grepFastaFromFileStandalone.pl $(dataName).faa $< > $@

%.gi : %.syn
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $(MACHINE)/pttsSyn2Gi.pl $(ptts) $< > $@ 

# create copy of effectors
$(dataName).$(effName).syn : $(eff)
	$(ECHO)
	$(ECHO) === creating $@ ===
	cp $^ $@


### get HSMM.lrt score lrt score
$(dataName).HSMM.lrt : $(dataName).faa$(SIG_EXT)
	$(ECHO)
	$(ECHO) === creating $@ ===
	cat $< | perl -F"\t" -lane 'print $$F[5]' | perl -pe 's/#lrt\(model1,model2\)/HSMM_score/' > $@ 

# Score based on hsmm
$(dataName).faa$(SIG_EXT) : $(dataName).faa $(dataName).ptts $(dataName).syn $(dataName).len $(dataName).gen $(dataName).prod
	$(ECHO)
	$(ECHO) === creating $@ ===
	make -f ~/signal/hsmmSignal/make.lrt.makefile faa=$< info -j2 


# Get similarity to effector from all agaist all blast
$(dataName).$(effName).sim2eff : $(MACHINE)getBlastAllVsAllInfo.pl $(blastDir)$(name).all.vs.all.blastp $(eff) $(dataName).ptts
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $(wordlist 1,2,$^) $(EVALUE_THRESHOLD) -E $(wordlist 3,4,$^) > $@

# Blast all against all of the genomes in question
$(blastDir)$(name).all.vs.all.blastp : $(dataName).faa.phr
#$(blastDir)%.all.vs.all.blastp : $(dataDir)%.faa.phr $(blastDir)
	$(ECHO)
	$(ECHO) === creating $@ \(Blasting...\) ===
	blastall $(BLAST_FLAGS) -i $(basename $<) -d $(basename $<) > $@

# Get distance to closest effector
$(dataName).$(effName).dist :  $(MACHINE)getDistanceFromEffector.pl $(eff) $(dataName).ptts 
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $^ -O > $@

# Get density of effector in close proximity
$(dataName).$(effName).dens : $(MACHINE)loopEffectorDensity.pl  $(eff) $(dataName).ptts 
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $^ $(dens) $(basename $(@)) $(MACHINE) > $@

# Get for each ORF is it an effector or not (unknown are consider not effectors)
$(dataName).$(effName).isEff : $(MACHINE)isInList.pl $(dataName).syn.list $(eff) $(non)
	$(ECHO)
	$(ECHO) === creating $@ ===
	echo is_effector > $@
	perl -w $^ >> $@

# Create synonym field for each ORF
$(dataName).syn : $(dataName).syn.list 
	$(ECHO)
	$(ECHO) === creating $@ ===
	echo Synonym > $@
	cat $^ >> $@

# Create synonym list
$(dataName).syn.list : $(MACHINE)printPttsCol.pl $(dataName).ptts 
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $^ 'Synonym' > $@

# Create length field for each ORF
$(dataName).len: $(MACHINE)printPttsCol.pl $(dataName).ptts 
	$(ECHO)
	$(ECHO) === creating $@ ===
	echo Length > $@
	perl -w $^ 'Length' >> $@

# Create gene name field for each ORF
$(dataName).gen: $(MACHINE)printPttsCol.pl $(dataName).ptts 
	$(ECHO)
	$(ECHO) === creating $@ ===
	echo Gene > $@
	perl -w $^ 'Gene' >> $@

# Create PID (GI) field for each ORF
$(dataName).pid: $(MACHINE)printPttsCol.pl $(dataName).ptts 
	$(ECHO)
	$(ECHO) === creating $@ ===
	echo GI > $@
	perl -w $^ 'PID' >> $@

# Create gene name field for each ORF
$(dataName).prod: $(MACHINE)printPttsCol.pl $(dataName).ptts 
	$(ECHO)
	$(ECHO) === creating $@ ===
	echo Product > $@
	perl -w $^ 'Product' >> $@

## create fasta of regulatort region
$(dataName).sig : $(MACHINE)processSignals.pl $(signals) 
	$(ECHO)
	$(ECHO) === processing signals ===
	perl -w $^ $(dataName) $@
##

# create blink feature out of all blink data
$(dataName).blink : $(dataDir)blink.log $(MACHINE)getBlinkTaxInfo.pl $(dataName).ptts 
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $(filter-out $<,$^) $(blinkDir) all > $@
# The above line filter out the first word out of the command

# Get blink data
# Note that the following is being done all over if ANYTHING changed in the blinkDir...
$(dataDir)blink.log : $(MACHINE)getBlinkPages.pl $(dataName).ptts $(blinkDir)
	$(ECHO)
	$(ECHO) === Fetching Blink data ===
	perl -w $^
	echo "JUST DID: $^" > $@

################################## UNDER CONSTRUCTION ##################################
# Get seconday structure data
# Note that the following is being done all over if ANYTHING changed in the strucDir...
$(dataDir)PsiPred.list : $(SCRIPTS)splitFasta.pl $(dataName).faa
	$(ECHO)
	$(ECHO) === Copying Fasta to stucture directory Fast ===
	cp $(dataName).faa $(strucDir)
	$(ECHO)
	$(ECHO) === Fetching Splitting Fasta file for each ORF ===
	perl -w $< $(strucDir)$(name).faa 
	$(ECHO)
	$(ECHO) === Removing full Fasta from stucture directory Fast ===
	$(RM) $(strucDir)$(name).faa 
	$(ECHO)
	$(ECHO) === Creating $@ ===
	find $(strucDir) -name "*.faa" > $@

$(dataDir)PsiPred.list.finish.log : $(MACHINE)producePsiPredSge.pl $(dataDir)PsiPred.list
	$(ECHO)
	$(ECHO) === Computing struc data (will submit job to queue pupko if needed)  ===
	perl -w $^ pupko
	$(ECHO)
	$(ECHO) === Cleaning unneeded ss struc files  ===
	find $(strucDir) -maxdepth 1 -name "*.ss" -delete 
	$(ECHO)
	$(ECHO) === Cleaning unneeded horiz struc files  ===
	find $(strucDir) -maxdepth 1 -name "*.horiz" -delete 
	$(ECHO)


########################################################################################
# GC content
$(dataName).gc : $(MACHINE)getGcContentFromPtt.pl $(dataName).ptts
	$(ECHO)
	$(ECHO) === creating $@ ===
	perl -w $^ > $@

# Format fasta files for blasts
%.phr: %
	$(ECHO)
	$(ECHO) === formating $> for blast search ===
	formatdb $(FORMATDB_FLAGS) -i $<

# Unite fasta file
$(dataName).faa : $(faaFiles)
	$(ECHO)
	$(ECHO) === creating $@ ===
#	cat $(filter-out $<,$^) > $@
	cat $^ > $@

# The above line filter out the first word out of the command

$(blastDir)$(name).faa : $(dataName).faa
	$(ECHO)
	$(ECHO) === creating $@ ===
	cp $^ $@

# Create list of ptt file
$(dataName).ptts : $(ptts) $(blastDir)$(name).faa 
	$(ECHO)
	$(ECHO) === copying $@ ===
	cp $< $@
#	echo "$^" | perl -e 'print join("\n",split(/\s+/,<>))."\n"' > $@ 
############################################

### Check existance of $(eff) $(non) $(ptts) $(faaFiles) ###
$(eff) :
	$(ECHO) OOOOPS: $@ does not exists
	@exit 2

$(non) :
	$(ECHO) OOOOPS: $@ does not exists
	@exit 2

$(ptts) :
	$(ECHO) OOOOPS: $@ does not exists
	@exit 2
################## HELP #####################

# A phony target is one that is not really the name of a file. It is just a name for some commands to be executed when you make an explicit request
.PHONY: Help checkParams makeDirs test Basics makeMenu cleanCsv cleanAll clean

# make help - print 
help: 
	$(ECHO) $(USAGE)

################# CLEAN ####################

# clean: delete all feature files (excluding blastp files and blink files)
# -: To ignore errors in a command line, write a `-' at the beginning of the line's text (after the initial tab). The `-' is discarded before the command is passed to the shell for execution.
clean: cleanCsv
	$(ECHO)
	$(ECHO) === Cleaning features but not data \(blastp and blink\) ===
	$(RM) $(dataDir)/*.*

# cleanAll: delete all data create by makefile
# -: To ignore errors in a command line, write a `-' at the beginning of the line's text (after the initial tab). The `-' is discarded before the command is passed to the shell for execution.
cleanAll: cleanCsv
	$(ECHO)
	$(ECHO) === Cleaning EVERYTHING  ===
	$(RM) -R $(dataDir)

# cleanCsv: delete final csv create by makefile
# -: To ignore errors in a comand line, write a `-' at the beginning of the line's text (after the initial tab). The `-' is discarded before the command is passed to the shell for execution.
cleanCsv:
	$(ECHO)
	$(ECHO) "=== Clean final .csv(s) (if exist) ==="
	$(RM)  $(name).$(effName).NoSignals.csv
	$(RM)  $(name).$(effName).csv

############################################
# usage 
 USAGE = 'This makefile requires the following variables to be defined:\n\
 name=<simple text with no spaces>\n\
 ptts=<full path of file with list of ptt files (in the same location faa files with the same base name as the ptt files is expected\n\
 databases=<list of fasta files that are going to be used with blast\n\
 dens=<min size neighbourhood> <max size neighbourhood> <step of neighbourhood size>\n\
 eff=<list of effectors gene names (synonyms)>\n\
 non=<list of NON-effectors gene names (synonyms)>\n\
 signals="<signal parameter file>" (see theEffectorMachine/featureCompiler/processSignals.pl)\n
 additionals = "<additional precomputed columns>" \n\n\
This can be included in the a makefile\n\
 here is an example:\n\n\
 =========================\n\
 \#!/usr/bin/gmake -f\n\n\
 name = Xcv8510\n\
 ptts = /specific/a/netapp2/vol/private/talpu/davidbur/PlantsPathogens/Xcv8510/Xcv8510.2.ptts\n\
 databases =  /specific/a/netapp2/vol/private/talpu/davidbur/PlantsPathogens/Xcv8510/mamalian.eff.faa /specific/a/netapp2/vol/private/talpu/davidbur/PlantsPathogens/Xcv8510/phytopatogens.faa /specific/a/netapp2/vol/private/talpu/davidbur/PlantsPathogens/Xcv8510/Xantho.non8510.eff.faa /specific/a/netapp2/vol/private/talpu/davidbur/PlantsPathogens/Xcv8510/Xcv8510.put.faa\n\
 dens = 5 30 5\n\
 eff = /specific/a/netapp2/vol/private/talpu/davidbur/PlantsPathogens/Xcv8510/Xcv8510.eff\n\
 non = /specific/a/netapp2/vol/private/talpu/davidbur/PlantsPathogens/Xcv8510/Xcv8510.noneff\n\
 signals="/specific/a/netapp2/vol/private/talpu/davidbur/PlantsPathogens/Xcv8510/XcvSignals.txt"\n\
 \ninclude ~/theEffectorMachine/featureCompiler/makeCompileFeaturesByPtts.makefile\n\
 ===========================\n\n'

############################################

# internal test
test: $(dataName).faa 
	$(ECHO) $(pttFiles)
	$(ECHO) $(faaFiles)


#### Check whether parameters were defined #####
checkParams:
ifndef name
	$(ECHO) "missing base name (please use full path and no extension, relevant extension will be added)"
	$(ECHO) $(USAGE)
	@exit 2
endif
ifndef databases
	$(ECHO) "missing databases (may be a number of databases to compare to (BLASTP-wise) please use full path)"
	$(ECHO) $(USAGE)
	@exit 2
endif


makeDirs:
	$(ECHO) === creating directories ===
	test -d $(dataDir) || mkdir $(dataDir) 
	test -d $(blinkDir) || mkdir $(blinkDir)
	test -d $(blastDir) || mkdir $(blastDir)
	test -d $(strucDir) || mkdir $(strucDir)

# # create data directory
# $(dataDir):
# 	$(ECHO)
# 	$(ECHO) === creating directory $@ ===
# 	-mkdir $@

# # create blink directory
# $(blinkDir): $(dataDir)
# 	$(ECHO)
# 	$(ECHO) === creating directory $@ ===
# 	-mkdir $@

# # create structure directory
# $(strucDir): $(dataDir)
# 	$(ECHO)
# 	$(ECHO) === creating directory $@ ===
# 	-mkdir $@

# # create blast directory
# $(blastDir): $(dataDir)
# 	$(ECHO)
# 	$(ECHO) === creating directory $@ ===
# 	-mkdir $@


# $@ - The file name of the target of the rule.
# $< - The name of the first prerequisite. 
# $? - The names of all the prerequisites that are newer than the target
# $^ - The names of all the prerequisites, with spaces between them. 
