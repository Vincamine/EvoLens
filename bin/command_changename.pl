#!/usr/bin/perl
use strict;




my @phy = glob("*_dna");

my %hash; 


for (my $i = 0;$i <= $#phy; $i++){ 
    #open IA, "<SHOX2_aling_DNA.fasta" or die;
    #open IA, "$ARGV[0]" or die;
    open IA,"<$phy[$i]" or die;
    open OA, ">$phy[$i].newphy" or die;
    while(<IA>){        
	    chomp;
            if(/^\d/){
                 print $_, "\n";

        }else{
              my @aa = split /\s+/, $_; 
              my @bb = split /_/, $aa[0]; 
              my $cc = $aa[0];
	      my $dd = substr($bb[0],0,4).substr($bb[1],0,1);
              #print $bb[0](0,4).$bb[1](0,1);
              print OA $dd . "  " . $aa[1], "\n"; 
              $hash{$cc}=$dd;  


	};
    }
    close IA;
    close OA;
}


open IA, "< tree" or die;
open OA, "> tree.out" or die;
    while(<IA>){
	   chomp;
	   foreach my $key (keys %hash){
		   $_ =~ s/$key/$hash{$key}/g;
		   print OA $_;
	   };

    }


close IA;
close OA;