from Bio.Phylo.PAML import codeml

def detect_positive_selection(alignment, tree, output_file):
    """
    Runs CODEML to estimate dN/dS ratios using a maximum likelihood approach.
    dN/dS > 1 indicates positive selection.
    """
    cml = codeml.Codeml()
    cml.alignment = alignment
    cml.tree = tree
    cml.out_file = output_file
    cml.working_dir = "./"

    # Model setup: 
    cml.set_options(seqtype=1, model=2, NSsites=[2])  # MLE for positive selection

    cml.run()
    print(f"Positive selection analysis completed. Results saved to {output_file}")

if __name__ == "__main__":
    detect_positive_selection("aligned_output.fasta", "phylogenetic_tree.nwk", "positive_selection_results.txt")