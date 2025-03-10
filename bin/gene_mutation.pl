#!/usr/bin/perl
use strict;

my %hash;

open IFg, "<LTQL.gene" or die;

#my %hash;

    <IFg>;
    while(<IFg>){
        chomp;
        my @aa = split /\t/, $_;
        #$hash{$aa[3]} = $aa[0].$aa[1].$aa[2];    #-1    
        #$hash{$aa[-1]} = $aa[0]."_".$aa[1]."_".$aa[2];
        
	$hash{$aa[3]} = $_;  
}
close IFg;

open IFm, "<LTQL.mutation" or die;
open OF, ">L.out" or die;
    <IFm>;
    print OF  "Chromosome\tstart\tend\tGene\tnumber\tinformation\n";
    while(<IFm>){
	    chomp;
	    my @bb = split /\t/, $_;
	    foreach my $key (keys %hash){
		    my @value = split /\t/, $hash{$key} ;
		    if($value[0] == $bb[0] and $value[1] < $bb[1] and $bb[1] < $value[2]){
                    # if($value[1] < $bb[1] < $value[2]){
	                         
                    #my $bbout = $bb[2]."=>".$bb[3].";";
                    #my $bbout1 = $bb[1];
                    
		    my $bbout = $bb[1] . ":" . $bb[2]."=>".$bb[3].";";
		    $hash{$key}	= $hash{$key} . "\t" .  $bbout;    #更新hash

                    #print OF $hash{$key} . "\t" . $bbout1 . ":" . $bbout . "\n";		  
          }
                    #else{print OF $hash{$key} . "\t" . "None" . "\n";}行不通只要不匹配就输出None

		    }}

close IFm;

foreach my $key (keys %hash){
        my @value = split /\t/,$hash{$key};
        #print OF $value[0] . "\t" . $value[1] . "\t" . $value[2] . "\t" . $value[3] . "\t" . $value[4] "\n";

       my $number = $#value+1-4;
       #if($number == 0) {print OF "none"}
       if($number == 0) {print OF join("\t",@value[0..3]), "\t","$number","\t","none","\n"; }
       else{
       print OF join("\t",@value[0..3]), "\t","$number","\t",join("",@value[4..$#value]),"\n";}

}
close OF;


