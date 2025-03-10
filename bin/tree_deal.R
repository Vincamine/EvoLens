## this is how to do it only by using R
library(ape)
species.tree <- read.tree("species_tree")
species.name <- species.tree$tip.label
files <- list.files(pattern = "*.newphy$")
for(i in files){
	print(i)
	files.fasta <- read.table(i, stringsAsFactors = F, skip = 1)
	files.name <- files.fasta[, 1]
	files.name <- files.name[-which(files.name == "Ailum")]
	files.drop <- setdiff(species.name, files.name)
	files.drop <- files.drop[-which(files.drop == "Ailum#1")]
	files.newtree <- drop.tip(species.tree, files.drop)
	write.tree(files.newtree, paste(i, ".newtree", sep = ""))
}
