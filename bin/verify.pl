#!/usr/bin/perl
use strict;


open IF,"<./count_2ail.out" or die;
#open OF,">./" or die;
<IF>;  
while(<IF>){
	chomp;
	my @inf0 = split /\t/,$_;
	if($inf0[-1] ne "none" ){
#		print "$inf0[0] @list1[0]\n";
		open IA,"<./$inf0[0]\_alnAA.newfas" or die;
		open OA,">./$inf0[0]\_alnAA.newfas.oneline" or die;

		$/=">"; 
		my %hash;
		my %gap;
		my $length;
		while(<IA>){
			chomp;
			my @inf1 = split /\n/, $_;
			my $seq = join ("",@inf1[1..$#inf1]);
			my @inf2 = split /_/, $inf1[0];
			my $name = substr($inf2[0],0,4).substr($inf2[1],0,1);

			$length = length($seq);
			for (my $i = 0; $i <= length($seq); $i++){
				$hash{$name}[$i] = substr($seq,$i,1);

				if(substr($seq,$i,1) eq "\-"){
					$gap{$i} = 0;
				};
			}
		}
		close IA;

		foreach my $key (keys %hash){
			print OA "$key  ";
			for (my $i = 0; $i <= $length; $i++){
				if(exists $gap{$i}){
				}else{
					print OA "$hash{$key}[$i]";
				}
			}
			print OA "\n";
		}
		close OA;


		my @list0 = split /;/,$inf0[-1];
#		my @list1 = split /:/,$list0[0];
		open IA,"<./$inf0[0]\_alnAA.newfas.oneline" or die;
		open OA,">./$inf0[0]\_alnAA.out" or die;
		$/ = "\n";
		<IA>;
		while(<IA>){
			chomp;
			my @aa = split /\s+/,$_;
			print OA "$aa[0]\t";
			for (my $i = 0; $i <= $#list0; $i++){
				my @bb = split /:/,$list0[$i];
				my $cc = substr($aa[1], $bb[0] - 1, 1);

				print OA "$bb[0]:$bb[1]|$cc\t";
			}
			print OA "\n";
		}
		close IA;
		close OA;
	};
};
close IF;
#close OF;
