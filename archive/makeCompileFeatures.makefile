#!/usr/bin/gmake -f

# This makefile is used to compile the features 
# If you are lost use:
# make help
#
# Other options:
# -------------
# make all
# make blasts
# make blink
# make clean
# make cleanAll
#


# use help if you are lost
USAGE = "USAGE: makeIndependentFeatures.makefile eff=path/effectors_list non=path/effectors_list name=fullpath/basename databases=fullpath1/file1.faa, fullpath2/file2.faa,.. [acc=ncbi_acc_1 ncbi_acc_2 ..]"
USAGE2 = "       name should contain no extension (will be added) databases will be used for blastp. acc should be added if united .faa  and ptts file is needed."
USAGE3 = "       sig=\"pssm.csv sigRegExp\" reg=\"regPssm.csv upstream downstream\" can be specified dens = max number of ORF in each side in biggest density search" 

### flags 
MACHINE = ~/pupkoSVN/trunk/programs/theEffectorMachine/
APPEND = perl -w ~/pupkoSVN/trunk/scripts/horizontalAppendMany.pl ,
BLAST_FLAGS = -p blastp -IT
FORMATDB_FLAGS = -pT
RM_FLAGS = -f -v
EVALUE_THRESHOLD = 0.01

### variables
dataDir = $(Dir)data/
blinkDir = $(dataDir)blink/
effName = $(subst $(name).,,$(notdir $(eff)))

pttFiles = $(addprefix $(nameDir),$(addsuffix .ptt,$(acc)))
faaFiles = $(addprefix $(nameDir),$(addsuffix .faa,$(acc)))

pttFiles = *.ptt
faaFiles =  $(pttFiles:.ptt=.faa)


sigPssm = $(firstword $(sig))
sigRegexp =  $(word 2,$(sig))

regPssm = $(firstword $(reg))
regRegion =  $(wordlist 2,3,$(reg))

dbBases = $(basename $(notdir $(databases)))
dbTargets = $(addsuffix .blastp.vals, $(addprefix $(dataDir)$(name).vs.,$(dbBases)))
############################################

#".SECONDARY with no prerequisites causes all targets to be treated as secondary (i.e., no target is removed because it is considered intermediate)."
.SECONDARY :

### BLASTP template: the parameter $1 is an faa file that is blasted against $(name).faa
define BLASTP_template
$(dataDir)$$(name).vs.$$(basename $$(notdir $(1))).blastp: $(1).phr
	@echo
	@echo === creating $$@ \(Blasting...\) ===
	blastall $$(BLAST_FLAGS) -i $$(dataDir)$$(name).faa -d $(1) > $$@
endef


### Default: make EVERYTHING - you need faaFils ans pttFiles (creates the ....train.csv and .....data.csv).
all : checkParams $(faaFiles) $(pttFiles) $(dataDir) $(dataDir)$(name).$(effName).train.csv $(dataDir)$(name).$(effName).data.csv

# Make the blasts only
blasts: $(dataDir) $(basename $(dbTargets)) $(dataDir)$(name).all.vs.all.blastp

# make blink (produces blink data)
blink : $(dataDir)blink.log $(blinkDir)

# Take trainset out of the all set.
%.train.csv : $(MACHINE)printCsvSubset.pl %.csv %.train.list
	@echo
	@echo === creating $@ ===
	perl -w $^ > $@

# Take dataset out of the all set.
%.data.csv : $(MACHINE)printCsvSubset.pl %.csv %.data.list
	@echo
	@echo === creating $@ ===
	perl -w $^ > $@

# Append features dependent and independent of effector list
%.$(effName).csv : %.independentFeatures.csv %.$(effName).dependentFeatures.csv
	@echo
	@echo === And now, at last, creating $@ ===
	$(APPEND) $^ > $@

# Append all features independent of effector list
%.independentFeatures.csv : %.syn %.len %.gen %.gc %.blink %.sig %.reg $(dbTargets)
	@echo
	@echo === Finally creating $@ ===
	$(APPEND) $^ > $@

# Append all features dependent of effector list
%.dependentFeatures.csv : %.sim2eff %.dist %.dens.1-$(dens) %.isEff
	@echo
	@echo === Finally creating $@ ===
	$(APPEND) $^ > $@

# Get relevent values out of blastp
%.blastp.vals : $(MACHINE)featureCompiler/getBlastAllVsAllInfo.pl %.blastp
	@echo
	@echo === creating $@ ===
	perl -w $^ $(EVALUE_THRESHOLD) -T $(patsubst $(name).vs.%.blastp.vals,%,$(notdir $@)) > $@

### Using BLASTP Template to create blastp dependencies ####
$(foreach database,$(databases),$(eval $(call BLASTP_template,$(database))))
####

# Get similarity to effector from all agaist all blast
%.$(effName).sim2eff : $(MACHINE)featureCompiler/getBlastAllVsAllInfo.pl %.all.vs.all.blastp $(eff) %.ptts
	@echo
	@echo === creating $@ ===
	perl -w $(wordlist 1,2,$^) $(EVALUE_THRESHOLD) -E $(wordlist 3,4,$^) > $@

# Blast all against all of the genomes in question
%.all.vs.all.blastp : %.faa.phr
	@echo
	@echo === creating $@ \(Blasting...\) ===
	blastall $(BLAST_FLAGS) -i $(basename $^) -d $(basename $^) > $@

# Get distance to closest effector
%.$(effName).dist :  $(MACHINE)featureCompiler/getDistanceFromEffector.pl $(eff) %.ptts 
	@echo
	@echo === creating $@ ===
	perl -w $^ -O > $@

# Get density of effector in close proximity
%.$(effName).dens.1-$(dens) : $(MACHINE)featureCompiler/loopEffectorDensity.pl  $(eff) %.ptts 
	@echo
	@echo === creating $@ ===
	perl -w $^ $(dens) $(basename $(@))

# Get for each ORF is it an effector or not (unknown are consider not effectors)
%.$(effName).isEff : $(MACHINE)isInList.pl %.syn.list $(eff)
	@echo
	@echo === creating $@ ===
	echo is effector > $@
	perl -w $^ >> $@

# Create synonym field for each ORF
%.syn : %.syn.list 
	@echo
	@echo === creating $@ ===
	echo Synonym > $@
	cat $^ >> $@

# Create synonym list
%.syn.list : $(MACHINE)featureCompiler/printPttsCol.pl %.ptts 
	@echo
	@echo === creating $@ ===
	perl -w $^ 'Synonym' > $@

# Create length field for each ORF
%.len: $(MACHINE)featureCompiler/printPttsCol.pl %.ptts 
	@echo
	@echo === creating $@ ===
	echo Length > $@
	perl -w $^ 'Length' >> $@

# Create gene name field for each ORF
%.gen: $(MACHINE)featureCompiler/printPttsCol.pl %.ptts 
	@echo
	@echo === creating $@ ===
	echo Gene > $@
	perl -w $^ 'Gene' >> $@

# Create regulatory data 
%.reg : $(MACHINE)Regulation/getBestPssmScore.pl $(regPssm) %.bg.reg %.reg.fna
	@echo
	@echo === creating $@ ===
	perl -w $^ > $@

# Create regulatory background data
%.bg.reg : $(MACHINE)machine/createPssmOfBg.pl %.reg.fna
	@echo
	@echo === creating $@ ===
	perl -w $^ > $@

# create fasta of regulatort region
%.reg.fna : $(MACHINE)featureCompiler/getRegulatoryRegion.pl %.ptts
	@echo
	@echo === creating $@ ===
	perl -w $^ $(regRegion) > $@

# create fasta of regulatort region
%.sig : $(MACHINE)Regulation/getBestPssmScore.pl $(sigPssm) %.bg.sig %.faa
	@echo
	@echo === creating $@ ===
	perl -w $^ -E '$(sigRegexp)' > $@

# create fasta of regulatort region
%.bg.sig : $(MACHINE)machine/createPssmOfBg.pl %.faa
	@echo
	@echo === creating $@ ===
	perl -w $^ '$(sigRegexp)' > $@

# create fasta of regulator region
%.blink : $(dataDir)blink.log $(MACHINE)featureCompiler/getBlinkTaxInfo.pl %.ptts $(blinkDir)
	@echo
	@echo === creating $@ ===
	perl -w $(filter-out $<,$^) > $@
# The above line filter out the first word out of the command

# Get blink data
# Note that the following is being done all over if ANYTHING changed in the blinkDir...
$(dataDir)blink.log : $(MACHINE)featureCompiler/getBlinkPages.pl $(dataDir)$(name).ptts $(blinkDir)
	@echo
	@echo === Fetching Blink data ===
	perl -w $^
	echo "JUST DID: $^" > $@

# GC content
%.gc : $(MACHINE)featureCompiler/getGcContentFromPtt.pl %.ptts
	@echo
	@echo === creating $@ ===
	perl -w $^ > $@

# create list of ORFs in training set
%.$(effName).train.list : $(eff) $(non)
	@echo
	@echo === creating $@ ===
	cat $^ > $@

# create list of ORFs in data set
%.$(effName).data.list : $(MACHINE)featureCompiler/printPttsCol.pl %.ptts %.$(effName).train.list 
	@echo
	@echo === creating $@ ===
	perl -w $(wordlist 1,2,$^) Synonym -E $(word 3,$^) > $@

# Format fasta files for blasts
%.faa.phr: %.faa
	@echo
	@echo === formating $> for blast search ===
	formatdb $(FORMATDB_FLAGS) -i $<

# Format fasta files for blasts
%.pep.phr: %.pep
	@echo
	@echo === formating $> for blast search ===
	formatdb $(FORMATDB_FLAGS) -i $<

# Unite fasta file
$(dataDir)$(name).faa : $(faaFiles)
	@echo
	@echo === creating $@ ===
	cat $^ > $@

# Create list of ptt file
$(dataDir)$(name).ptts : $(pttFiles)
	@echo
	@echo === creating $@ ===
	echo "$^" | perl -e 'print join("\n",split(/\s+/,<>))."\n"' > $@ 

# create data directory
$(dataDir):
	@echo
	@echo === creating directory $@ ===
	mkdir $@

# create blink directory
$(blinkDir):
	@echo
	@echo === creating directory $@ ===
	mkdir $@
############################################

### Check existance of $(eff) $(non) $(faaFiles) ###
$(eff) :
	@echo OOOOPS: $@ does not exists
	@exit 2

$(non) :
	@echo OOOOPS: $@ does not exists
	@exit 2

$(faaFiles) :
	@echo OOOOPS: $@ does not exists
	@exit 2

$(pttFiles) :
	@echo OOOOPS: $@ does not exists
	@exit 2
################## HELP #####################

.PHONY: help checkParams test 

# make help - print 
help: 
	@echo $(USAGE)
	@echo $(USAGE2)
	@echo $(USAGE3)

################# CLEAN ####################

# clean: delete all feature files (excluding blastp files and blink files)
# -: To ignore errors in a command line, write a `-' at the beginning of the line's text (after the initial tab). The `-' is discarded before the command is passed to the shell for execution.
clean:
	@echo
	@echo === Cleaning features but not data \(blastp and blink\) ===
	-mkdir -p $(dataDir)temp4blastp
	-mv $(dataDir)*.blastp $(dataDir)temp4blastp/
	-rm $(RM_FLAGS) $(dataDir)/*.*
	-mv $(dataDir)temp4blastp/* $(dataDir)
	-rmdir $(dataDir)temp4blastp

# cleanAll: delete all data create by makefile
# -: To ignore errors in a command line, write a `-' at the beginning of the line's text (after the initial tab). The `-' is discarded before the command is passed to the shell for execution.
cleanAll:
	@echo
	@echo === Cleaning EVERYTHING  ===
	-rm -R $(RM_FLAGS) $(dataDir)

############################################

# internal test
test:
	@echo sigPssm = $(sigPssm)
	@echo acc = $(acc)
	@echo dbTargets = $(dbTargets)
	@echo $(MACHINE)featureCompiler/getBlastAllVsAllInfo.pl $(dataDir)$(name).$(effName).all.vs.all.blastp $(eff) $(dataDir)$(name).ptts


#### Check whether parameters were defined #####
checkParams:
ifndef name
	@echo "missing base name (please use full path and no extension, relevant extension will be added)"
	@echo $(USAGE)
	@exit 2
endif
ifndef databases
	@echo "missing databases (may be a number of databases to compare to (BLASTP-wise) please use full path)"
	@echo $(USAGE)
	@exit 2
endif
