#!/usr/bin/gmake -f

# this make will gather the needed information to run the makeCompileFfeaturesByPtts.makefile, and run it.
# the pupose is to allow performing the learning done for L.pneumophila for every Legionella species separately.
# Usage of the makefile is as follows:

USAGE = "make -f makeLearningHappen.makefile pos=<positive set> neg=<negative set> ptts=<file containing list of relevant ptt files>"

HOME = /groups/pupko/davidbur/
QUEUE = pupko
# -aL alignment coverage for the longer sequence (0.0 - 1.0) less then that coverage won't be considered as same cluster
# e.g. -aL 0.8 means that the longer of the "duplicates" has to have atleast 0.8 of it sequence with 0.9 (default) identity with other sequences in the cluster
#CDHIT = /Applications/cd-hit-v4.5.4-2011-03-07/cd-hit -aL 0.8
CDHIT = /bioseq/cd_hit/cd-hit -aL 0.8
# -j - number of parallel processes to use. Note that in the makefile itself there might be additional use of parallelization
#     (e.g., recently I use blast that uses several CPUs) 
MAKE = make Shuman # -j 4

# remove linearFlag if Genomes (or genome pieces) are not linear (contigs = linear genomes)
linearFlag = -L

databases = /groups/pupko/davidbur/Sequences/Eukarya/Human.faa /groups/pupko/davidbur/Sequences/Eukarya/TTA1.pep /groups/pupko/davidbur/Sequences/Eukarya/dicty.pep /groups/pupko/davidbur/Coxiella/Combined_TIGR_NCBI.RSA493/RSA493.faa
dens = 5 30 5
signals = /groups/pupko/davidbur/LegionellaGenomes/Data/Factory/Leg292.signals
domains = /groups/pupko/davidbur/LegionellaGenomes/Data/eukDomains /groups/pupko/davidbur/LegionellaGenomes/Data/eukDomains.effSpecific /groups/pupko/davidbur/LegionellaGenomes/Data/eukDomains.notEffSpecific
name = $(basename $(notdir $(ptts)))
eff = $(pos).filtered.syn
non = $(neg).filtered.syn


Dir = $(dir $(ptts))
makefileFile = $(Dir)makefile
make_params = name ptts databases dens eff non signals domains linearFlag
faa = $(ptts:.ptts=.faa)
learnDataset = $(Dir)ShumanLearning/$(name).csv
learnResults = $(learnDataset).arff.vote.scores.csv
shortName = $(shell echo $(name) | perl -pe 's/^(.{7}).*/$$1/')

All : $(learnResults) checkParams

try :
	echo $(shortName)
	echo $(name)

# run the learnin scheme (invloves submitting stuff to the queue)
$(learnResults) : $(HOME)learningMachine/runLearningScheme.pl $(learnDataset)
	perl -w $^  -q $(QUEUE) -j $(shortName) 

# complie learning set (run the makefile that does it)
$(learnDataset) : $(makefileFile)
	$(MAKE) -f $< 

# get GIs from fasta headers and translate to synonym
%.filtered.syn : %.filtered.faa
	grep ">" $< | perl -pe 's/>gi\|(\d+)\|.*/$$1/' | perl -w /groups/pupko/davidbur/theEffectorMachine/pttsSyn2Gi.pl $(ptts) - PID Synonym > $@ 

# filter duplicates of faa (see $(CDHIT) for info on how duplicates are defined)
%.filtered.faa : %.faa
	$(CDHIT) -i $< -o $@

# gerp fasta subset based on GI
%.faa : %.gi
	perl -w $(HOME)scripts/grepFastaFromFileStandalone.pl  $(faa) $< > $@

# translate sysnoyms of homologs to gi of homologs
%.homologs.gi : %.homologs
	perl -w $(HOME)theEffectorMachine/pttsSyn2Gi.pl $(ptts) $< > $@ 

# print required variables into makefile
$(makefileFile) :  $(eff) $(non)
	@echo === producing makefile in $@ ===
	echo '#!/usr/bin/gmake -f' > $@
	echo '' >> $@
	date | perl -ne 'print "# $$_"' >>  $@
	$(foreach par,$(make_params),echo $(par) = $($(par)) >> $@;)
	echo '' >> $@
	echo 'include $(HOME)/theEffectorMachine/featureCompiler/makeCompileFeaturesByPtts.makefile' >> $@
	@echo


.SECONDARY:

.PHONY: help checkParams
help: 
	@echo $(USAGE)

clean:
	-rm -vf $(makefileFile) $(eff) $(non) $(pos).gi $(neg).gi $(pos).faa $(neg).faa $(pos).filtered.faa $(neg).filtered.faa $(pos).filtered.faa.clstr $(neg).filtered.faa.clstr $(pos).filtered.faa.bak.clstr $(neg).filtered.faa.bak.clstr 

checkParams:
ifndef ptts
	@echo "missing ptts file (containing list of relevant ptt files), please use full path"
	@echo $(USAGE)
	@exit 2
endif
ifndef pos
	@echo "missing positive set filename (please use full path)"
	@echo $(USAGE)
	@exit 2
endif
ifndef neg
	@echo "missing negative set filename (please use full path)"
	@echo $(USAGE)
	@exit 2
endif
