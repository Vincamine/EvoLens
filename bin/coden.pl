#!/usr/bin/perl

use strict;


my %CODE = (    
                                'GCA' => 'A', 'GCC' => 'A', 'GCG' => 'A', 'GCT' => 'A',                               # Alanine
                                'TGC' => 'C', 'TGT' => 'C',                                                           # Cysteine
                                'GAC' => 'D', 'GAT' => 'D',                                                           # Aspartic Acid
                                'GAA' => 'E', 'GAG' => 'E',                                                           # Glutamic Acid
                                'TTC' => 'F', 'TTT' => 'F',                                                           # Phenylalanine
                                'GGA' => 'G', 'GGC' => 'G', 'GGG' => 'G', 'GGT' => 'G',                               # Glycine
                                'CAC' => 'H', 'CAT' => 'H',                                                           # Histidine
                                'ATA' => 'I', 'ATC' => 'I', 'ATT' => 'I',                                             # Isoleucine
                                'AAA' => 'K', 'AAG' => 'K',                                                           # Lysine
                                'CTA' => 'L', 'CTC' => 'L', 'CTG' => 'L', 'CTT' => 'L', 'TTA' => 'L', 'TTG' => 'L',   # Leucine
                                'ATG' => 'M',                                                                         # Methionine
                                'AAC' => 'N', 'AAT' => 'N',                                                           # Asparagine
                                'CCA' => 'P', 'CCC' => 'P', 'CCG' => 'P', 'CCT' => 'P',                               # Proline
                                'CAA' => 'Q', 'CAG' => 'Q',                                                           # Glutamine
                                'CGA' => 'R', 'CGC' => 'R', 'CGG' => 'R', 'CGT' => 'R', 'AGA' => 'R', 'AGG' => 'R',   # Arginine
                                'TCA' => 'S', 'TCC' => 'S', 'TCG' => 'S', 'TCT' => 'S', 'AGC' => 'S', 'AGT' => 'S',   # Serine
                                'ACA' => 'T', 'ACC' => 'T', 'ACG' => 'T', 'ACT' => 'T',                               # Threonine
                                'GTA' => 'V', 'GTC' => 'V', 'GTG' => 'V', 'GTT' => 'V',                               # Valine
                                'TGG' => 'W',                                                                         # Tryptophan
                                'TAC' => 'Y', 'TAT' => 'Y',                                                           # Tyrosine
                                'TAA' => 'U', 'TAG' => 'U', 'TGA' => 'U'                                              # Stop
        );


open IA, "< ./mergedna_up.fasta" or die;
while(<IA>){
	chomp;	
	
	if(/^>/){
		print $_, "\n";
	}else{
		for(my $i = 0; $i < length($_); $i += 3){
			my $aa_seq = substr($_, $i, 2);
			my $aa1 = "$aa_seq"."A";
			my $aa2 = "$aa_seq"."T";
			my $aa3 = "$aa_seq"."C";
			my $aa4 = "$aa_seq"."G";
			my $aa0 = substr($_, $i, 3);
			my $aa5 = "$aa_seq"."-";

			if(($CODE{$aa1} eq $CODE{$aa2}) and  ($CODE{$aa2} eq $CODE{$aa3}) and ($CODE{$aa3} eq $CODE{$aa4}) and ($CODE{$aa1} eq $CODE{$aa4})){
				print $aa0;
	        	}else{
				print $aa5;
			};
#			print $i, "\t",  $CODE{$aa1}, "\t",  $CODE{$aa2}, "\t" , $CODE{$aa3}, "\t", $CODE{$aa4}, "\n";
		};
		print "\n";
	};

}
close IA;



