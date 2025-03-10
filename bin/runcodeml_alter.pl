#!/usr/bin/perl -w 
use strict;

open OT, ">run_ln_alter.sh" or die;


my $pwd = `pwd`;
chomp($pwd);
open IA, "<./gene_ail2andred_list" or die;
while(<IA>){
	chomp;
	my @inf = split /_/, $_;
	`mkdir $inf[0]` unless (-e $inf[0]);
	`mkdir $inf[0]/2alter` unless (-e "$inf[0]/2alter");
	open OA, ">./$inf[0]/2alter/codeml.ctl" or die;
	print OA <<RCD
seqfile = $pwd/$inf[0]_aln_dna.newphy
outfile = $pwd/$inf[0]/2alter/$inf[0].rst
treefile = $pwd/$inf[0]_align_DNA.newtree.2


  noisy = 3   * 0,1,2,3,9: how much rubbish on the screen
verbose = 1   * 1: detailed output, 0: concise output 
runmode = 0   * 0: user tree;  1: semi-automatic;  2: automatic
	                         * 3: StepwiseAddition; (4,5):PerturbationNNI

  seqtype = 1   * 1:codons; 2:AAs; 3:codons-->AAsCodonFreq = 2   * 0:1/61 each, 1:F1X4, 2:F3X4, 3:codon table
CodonFreq = 2   * 0:1/61 each, 1:F1X4, 2:F3X4, 3:codon table
    clock = 0   * 0: no clock, unrooted tree, 1: clock, rooted tree
    model = 2
                    * models for codons:
		    * 0:one, 1:b, 2:2 or more dN/dS ratios for branches
NSsites = 2   * dN/dS among sites. 0:no variation, 1:neutral, 2:positive
  icode = 0   * 0:standard genetic code; 1:mammalian mt; 2-10:see below


fix_kappa = 0  * 1: kappa fixed, 0: kappa to be estimated
    kappa = 2.5   * initial or fixed kappa
fix_omega = 0   * 1: omega or omega_1 fixed, 0: estimate
    omega = 1.5   * initial or fixed omega, for codons or codon-transltd AAs


fix_alpha = 1   * 0: estimate gamma shape parameter; 1: fix it at alpha
    alpha = 0  * initial or fixed alpha, 0:infinity (constant rate)
   Malpha = 0   * different alphas for genes
    ncatG = 10   * # of categories in the dG or AdG models of rates


       getSE = 0   * 0: don't want them, 1: want S.E.s of estimates
RateAncestor = 0   * (1/0): rates (alpha>0) or ancestral states (alpha=0)



fix_blength = 0  * 0: ignore, -1: random, 1: initial, 2: fixed
  *  method = 0   * 0: simultaneous; 1: one branch at a time
  cleandata = 1

  
* Specifications for duplicating results for the small data set in table 1
* of Yang (1998 MBE 15:568-573).
* see the tree file lysozyme.trees for specification of node (branch) labels

RCD
;
	close OA;
	
	open OA, ">$inf[0]/2alter/$inf[0].codeml.sh" or die;
	print OA "$pwd/codeml $pwd/$inf[0]/2alter/codeml.ctl\n";
	close OA;

	print OT "cd $inf[0]/2alter \nnohup sh $inf[0].codeml.sh 1>$inf[0].nohup.out 2>&1 &\ncd ../../\n";
}
close IA;
close OT;
