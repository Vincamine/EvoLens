import numpy as np
import pandas as pd
from scipy.stats import beta

def detect_rapid_evolution(input_file, output_file, threshold=1.0):
    """
    Identifies rapidly evolving genes using Bayesian inference on dN/dS ratios.
    A dN/dS ratio significantly greater than 1 suggests positive selection.
    """
    df = pd.read_csv(input_file)

    # Bayesian estimation: Use Beta distribution for dN/dS ratio
    df["Bayesian_Estimate"] = df["dN"] / (df["dN"] + df["dS"] + 1e-9)

    # Identify rapid evolution
    df["Rapid_Evolution"] = df["Bayesian_Estimate"] > threshold

    df.to_csv(output_file, index=False)
    print(f"Rapid evolution analysis saved to {output_file}")

if __name__ == "__main__":
    detect_rapid_evolution("selection_data.csv", "rapid_evolution_results.csv")