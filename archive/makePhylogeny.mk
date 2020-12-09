#!/usr/bin/gmake -f
#
# Purpose: given a set of lpgs (synonyms), build tree of the homologs of these ORFs 
#
# Usage of the makefile is as follows:
#
USAGE = "make -f makePhylogeny.mk LPG=<list of lpgs>"

SCRIPTS = /groups/pupko/davidbur/scripts/
# create tree usinf ginsi (mafft global alinments with iterations)
#ALIGN = ginsi
ALIGN = mafft --maxiterate 1000 --globalpair
# RAxML parameters including outgroup 
#RAxML = /usr/local/raxmlHPC/raxmlHPC -f a -x 1 -p 1 -N 100 -m GTRGAMMA  -o C.burnetii
RAxML = /groups/pupko/davidbur/Programs/standard-RAxML-master/raxmlHPC-PTHREADS-SSE3 -T 20 -f a -x 1 -p 1 -N 100 -m GTRGAMMA  -o CBUD

# a file with all the genes of all the organisms in it
FNA = /groups/pupko/davidbur/LegionellaGenomes/Data/Phylogeny/43joined.fna
# lpg from which to build phylogeny
#LPG = /groups/pupko/davidbur/LegionellaGenomes/Data/Phylogeny/Ciccarelli.COGs.no_lpg2031.lpg
LPG = /groups/pupko/davidbur/LegionellaGenomes/Data/Phylogeny/Ciccarelli.36.COGs.lpg
# file with locations of all relevant annots file (used to find homologs)
ANNOTS = /groups/pupko/davidbur/LegionellaGenomes/Data/40Leg.dugway.annots#42Leg.dugway.annots
# file with table of <short name>\t<full organism name> used to rename concatenated MSA
ORGANISMS_TABLE = /groups/pupko/davidbur/LegionellaGenomes/Data/Phylogeny/organisms.tab
# ortholog group (OG) file (output of makeOrthoMCL.mk: "<OG>:\tgene_1\tgene_2\t...\tgene_n\n" )
ORTHOLOG_GROUPS = /groups/pupko/davidbur/LegionellaGenomes/Data/Orthologs/LOGs.sorted.tab

DIR = $(dir $(LPG))
HOMOLOGS_LISTS = $(addsuffix .homologs, $(addprefix $(DIR), $(shell cat $(LPG))))
HOMOLOGS_FNAS = $(addsuffix .fna, $(HOMOLOGS_LISTS))
MSAS = $(HOMOLOGS_FNAS:.fna=.msa)
HOMO_TABLE = $(LPG).lpgs.tab
CONCAT_MSA = $(LPG).concat.msa


All : $(LPG).concat.short.header.outgrouped.renamed.tree
Table : $(HOMO_TABLE)
Homologs : $(HOMOLOGS_LISTS)
ConcatMsa : $(LPG).concat.msa

try : /groups/pupko/davidbur/LegionellaGenomes/Data/Phylogeny/lpg2357.homologs

# change short name to full name
%.renamed.tree : %.tree
	perl -w $(SCRIPTS)substituteMany.pl $< $(ORGANISMS_TABLE) > $@

# reconstruct tree 
%.outgrouped.tree  : %.phylip.msa 
	$(RAxML) -s $< -n $(notdir $*).outgrouped
	cp $(dir $*)RAxML_bipartitionsBranchLabels.$(notdir $*) $@

# convert fasta msa to phylip msa
%.phylip.msa  : %.msa
	perl -w $(SCRIPTS)convertMsaFormat.pl $^ $@ fasta phylip

# change header to first letter of synonyms the regEx is built such that it will change all those who has the same synonym prefix (eg lpg),
# if there are genes of different species only the ones with the same prefix will be changed - such that it is clear on the msa that there is a mix of species
%.short.header.msa : %.msa
	perl -pe 's/>([a-zA-Z]+)[\d_]+(\1[\d_]+)*(.*)/>$$1$$3/' $^ > $@

# (wisely) concatenate msas to on
$(LPG).concat.msa : $(MSAS)
	perl -w $(SCRIPTS)fastaMsaConcat.pl $^ >$@

# fna to msa
%.msa : %.fna
	$(ALIGN) $< > $@

# create fasta with relevant files based on homologs list
# this assumes there is a file with all the required fnas in $(FNA)
%.homologs.fna : %.homologs
	perl -w $(SCRIPTS)grepFastaFromFile.pl $(FNA) $< -J > $@


# create file of homologs in other genomes
####### NEW VESTION ##### take the list from ortholog group (OG) file (output of makeOrthoMCL.mk: "<OG>:\tgene_1\tgene_2\t...\tgene_n\n" )
$(DIR)%.homologs : $(ORTHOLOG_GROUPS)
	grep $* $^ | perl -pe 's/^(\w+\:)\t//;s/\t/\n/g' > $@
####### OLD VERSION ##### this assumes you have a table of homologs prepared by findHomologsBasedOnAnnot.pl 
#$(DIR)%.homologs : $(HOMO_TABLE)
#	perl -F"\t" -lane 'BEGIN{$$selected = 0;$$first=1} if($$first){foreach $$i (0..$$#F) {if ($$F[$$i] =~ /$*/){$$selected=$$i;last}}}; $$first = 0; $$_ = $$F[$$selected];print "\\b$$_\\b";warn "missing value" if /-/; warn "multiple values" if / /;' $< > $@

# create table of homologies based on annot files for a list of lpg
%.lpgs.tab : $(ANNOTS) %
	perl -w $(SCRIPTS)/legionellaGenomes/findHomologsBasedOnAnnot.pl $^

# gerp fasta subset based on GI
%.faa : %.gi
	perl -w $(SCRIPTS)grepFastaFromFileStandalone.pl  $(faa) $< > $@

.SECONDARY:

.PHONY: help checkParams
help: 
	@echo $(USAGE)

clean:
	-rm -vf $(HOMOLOGS_LISTS) $(HOMOLOGS_FNAS) $(MSAS) $(LPG).concat.msa $(LPG).concat.short.header.msa  $(LPG).concat.renamed.msa $(LPG).concat.renamed.phylip.msa 

checkParams:
ifndef LPG
	@echo "missing LPG file (containing list of relevant lpg genes)"
	@echo $(USAGE)
	@exit 2
endif
