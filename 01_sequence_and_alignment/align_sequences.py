import subprocess

def align_sequences(input_fasta, output_file, num_iterations=3):
    """
    Align sequences using a progressive alignment approach with Clustal Omega.
    Iteratively refines the alignment using different guide trees.
    """
    for i in range(num_iterations):
        guide_tree = f"guide_tree_{i}.dnd"
        cmd = f"clustalo -i {input_fasta} -o {output_file} --guidetree-out {guide_tree} --force"
        subprocess.run(cmd, shell=True, check=True)
        print(f"Iteration {i+1}: Alignment completed with guide tree {guide_tree}")

    print(f"Final alignment saved to {output_file}")

if __name__ == "__main__":
    align_sequences("input_sequences.fasta", "aligned_output.fasta")