from Bio import Phylo
from Bio.Phylo.TreeConstruction import DistanceCalculator, DistanceTreeConstructor
from Bio.Align import AlignIO

def build_tree(alignment_file, output_tree):
    """
    Constructs a phylogenetic tree using the Neighbor-Joining algorithm.
    Uses a distance matrix derived from sequence alignments.
    """
    alignment = AlignIO.read(alignment_file, "fasta")
    calculator = DistanceCalculator("identity")
    distance_matrix = calculator.get_distance(alignment)

    constructor = DistanceTreeConstructor(calculator, method="nj")
    tree = constructor.nj(distance_matrix)

    Phylo.write(tree, output_tree, "newick")
    print(f"Phylogenetic tree saved to {output_tree}")

if __name__ == "__main__":
    build_tree("aligned_output.fasta", "phylogenetic_tree.nwk")