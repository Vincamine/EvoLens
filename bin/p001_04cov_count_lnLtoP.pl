#!/usr/bin/perl -w
use strict;


open IF, "<./gene_ail2andred_list" or die;
open OF, ">./p001_04cov_count_2ail.out.test001" or die;
	print OF "gene\tforeground\tomega\tlnL0\tlnL1\t2D-lnL\tp_value\tQ_value\tselected-num\t*selected-num\tInformation\n";
#open OFf,">./ail2_posi_list" or die;
while(<IF>){
	chomp;
	my @i = split /_aln/, $_;
	my @a2;
	my @b2;
	my @a3;
	my @twod;
	my @a4;

	open IA,"<./$i[0]/2alter/$i[0].rst" or die;
#	print "$i[0]/2alter/$i[0].rst\n";
	open IB,"<./$i[0]/2null/$i[0].rst" or die;
#	print "$i[0]/2null/$i[0].rst\n";
#错误	open OFf,">./ail2_gene_posi" or die;
	my %hash;
	my $star = 0;
	my $star0 = 0;
	while(<IA>){
		chomp;
		if(/lnL/){
			my @a1 = split /\)\:\s+/, $_;
			@a2 = split /\+/, $a1[1];
#			print "lnL1=".$a2[0]."\n";

		};  
		if(/foreground w/){
			@a3 = split /\s/, $_;
#			print $i[0]." "."w=".$a3[-1]."\n";\
		};
		if(/\s+\d+\s+[A-Z]\s\d+\.\d/){
			my @a4 = split /\s/,$_;
#			print $a4[-3]."\t".$a4[-2]."-".$a4[-1]."\n";
			$hash{$a4[-3]} = "$a4[-3]:$a4[-2]:$a4[-1];"; #
		};
	};
	my $inf;
	foreach my $key (sort {$a <=> $b} keys %hash){
		if($hash{$key} =~ /\*/){
			$star ++;
			$inf = $inf.$hash{$key};
		}else{
			$star0 ++;
			$inf = $inf.$hash{$key};
		};
	};
	my $infall = $star + $star0;

	while(<IB>){
		chomp;
		if(/lnL/){
			my @b1 = split /\)\:\s+/, $_;
			@b2 = split /\+/,$b1[1];
#			print "lnL0=".$b2[0]."\n";
		};  

	};
	my $twod = 2 * abs ($b2[0] - $a2[0]);
	my $p = `chi2 1 $twod`;
	my @pp = split /\s+/, $p;
=cut
	my $posi;
	if($pp[-1] < 0.05){$posi = $i[0]."\n";}
	print $posi;
=cut
	if($infall > 0){
#		print $i[0]."\t".$infall."\t".$inf."\t"."stars".\n";
#		print "$i[0]\t$infall\t$star\t$inf\n";
		print OF "$i[0]\t2ail\t$a3[-1]\t$b2[0]\t$a2[0]\t$twod\t$pp[-1]\t$infall\t$star\t$inf\n";
	}else{
		print OF "$i[0]\t2ail\t$a3[-1]\t$b2[0]\t$a2[0]\t$twod\t$pp[-1]\t$infall\t$star\tnone\n"
	};		
	close IA;
	close IB;
}	
close IF;
close OF;
#close OFf;
