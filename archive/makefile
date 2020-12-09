#!/usr/bin/gmake -f

name = ~/Coxiella/dugway/dugway
reg = ~/Legionella/machine/pssm/pmrA.pssm.csv 300 0 
databases =  ~/Sequences/Eukarya/cow.pep /groups/pupko/davidbur/Sequences/Eukarya/humanNcbi.pep /groups/pupko/davidbur/Sequences/Eukarya/humanGnomon.pep /groups/pupko/davidbur/Legionella/sequences/all.145.effectors.faa
acc = 
sig = ~/Legionella/145.20C.Pssm.csv \w{20}$$
dens = 30
eff = dugway.8.eff
non = dugway.40.non

include ~/Legionella/theEffectorMachine/featureCompiler/makeCompileFeatures.makefile
