#!/usr/bin/perl
use strict;

my %hash; 

open IFm, "<LTQL.mutation" or die;
    <IFm>;
    while(<IFm>){
	    chomp;  
	    my @aa = split /\t/, $_;  
           

            #my @bb = $aa[0]." ".$aa[1]; my @cc = $aa[2]."=>".$aa[3];    #?requires explicit package name
	    
            #$hash{$aa[0]."\t".$aa[1]} = $aa[1].":".$aa[2]."=>".$aa[3];
            $hash{$aa[0]."\t".$aa[1]} = $_;   
    }
close IFm;


open IFg, "<LTQL.gene" or die;
open OF, ">L2.out" or die;
    <IFg>;
print OF "Chromosome\tstart\tend\tGene\tinformation\n";
    while(<IFg>){
	    chomp;
            my @dd = split /\t/, $_;
            

=cut                foreach my $key (keys %hash){
		    my @keycut = split /\t/, $key;
		    if($keycut[0] == $dd[0]){
		        if($keycut[1] > $dd[1] and $keycut[1] < $dd[2]){
		        my $keyout = $keycut[0]."\t".$keycut[1];
                        #print OF $dd[0]."\t".$dd[1]."\t".$dd[2]."\t".$dd[3]."\t".$keycut[1]."\n";}       
                        my $ddout = $dd[0]."\t".$dd[1]."\t".$dd[2]."\t".$dd[3]."\t"."\n";
			my @value = split /\t/, $hash{$key};

			$hash{$key} =  $ddout."\t".$value[1].":".$value[2]."=>".$value[3]."\n";
			print OF $hash{$key};
=cut
		
		    }
                        #else{print OF $dd[0]."\t".$dd[1]."\t".$dd[2]."\t".$dd        [3]."\t"."none"."\n";}

	    }
    
    }}
close IFg;

=cutforeach my $key(keys %hash){
        my @value = split /\t/, $hash{$key};
        my
}
=cut

close OF;

