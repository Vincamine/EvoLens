#!/usr/bin/perl -w
use strict;

open IA, "<./list_fromtree" or die;
my $tree = <IA>;
chomp $tree;
close IA;


my %all_species;
my @inf = split /,/, $tree;

for(my $i = 0; $i <= $#inf; $i++){
	$all_species{$inf[$i]} = 1;
}

#`rm *.newphy.R`;
#`rm *.newtree`;

my @phy = glob("*.newphy");

for (my $i = 0; $i <= $#phy; $i++){
	my @tip_remove;
	my %hash = %all_species;
	open IA, "<./$phy[$i]" or die;
	while(<IA>){
		chomp;
		if(/^\d/){
			next;
		}else{
			my @inf2 = split /\s+/, $_;
			if(exists $hash{$inf2[0]}){
				delete $hash{$inf2[0]};
			};
		};
	
	};
	close IA;
	foreach my $key (keys %hash){
		if($key !~ /#/){
			push @tip_remove, $key;
		}
	};

	my $aa = "\"". join("\",\"", @tip_remove). "\"";
	if($#tip_remove >= 0){
	open OA, ">./$phy[$i].R" or die;
	print "processing $phy[$i]\n";
	print OA <<RCD
library(ape)
a <- read.tree("species_tree")
a.remove <- drop.tip(a, c($aa))
write.tree(a.remove, "$phy[$i].newtree")

RCD
;
	close OA;
	`Rscript $phy[$i].R`;
	`rm $phy[$i].R`;	
	
	}else{
	`cp species_tree $phy[$i].newtree`;
	};
}
