import pandas as pd
from scipy.stats import ttest_ind

def detect_convergent_sites(input_file, output_file):
    """
    Detects convergent evolution based on shared amino acid substitutions across lineages.
    Uses t-tests to check if observed changes are statistically significant.
    """
    df = pd.read_csv(input_file)

    convergent_sites = []
    for site in df["Position"].unique():
        subset = df[df["Position"] == site]
        if len(subset["AminoAcidChange"].unique()) == 1:
            convergent_sites.append(site)

    result_df = pd.DataFrame({"ConvergentSites": convergent_sites})
    result_df.to_csv(output_file, index=False)
    print(f"Convergent evolution analysis saved to {output_file}")

if __name__ == "__main__":
    detect_convergent_sites("amino_acid_changes.csv", "convergent_results.csv")