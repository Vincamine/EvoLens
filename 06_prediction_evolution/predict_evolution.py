import numpy as np
import pandas as pd
import torch
import torch.nn as nn
import torch.optim as optim
from scipy.stats import beta
from Bio import AlignIO

# ========================== STEP 1: DATA PREPROCESSING ==========================

def extract_features(alignment_file):
    """
    Extracts sequence-based evolutionary features for prediction.
    Converts aligned sequences into numerical format for deep learning.
    """
    alignment = AlignIO.read(alignment_file, "fasta")
    sequences = [list(str(record.seq)) for record in alignment]
    seq_matrix = np.array(sequences)
    
    # Convert nucleotides to numeric values (A=0, C=1, G=2, T=3)
    mapping = {'A': 0, 'C': 1, 'G': 2, 'T': 3, '-': 4}
    numeric_matrix = np.vectorize(mapping.get)(seq_matrix)

    return numeric_matrix

# ========================== STEP 2: LSTM MODEL ==========================

class EvolutionLSTM(nn.Module):
    def __init__(self, input_size, hidden_size, output_size, num_layers=2):
        super(EvolutionLSTM, self).__init__()
        self.lstm = nn.LSTM(input_size, hidden_size, num_layers, batch_first=True)
        self.fc = nn.Linear(hidden_size, output_size)

    def forward(self, x):
        lstm_out, _ = self.lstm(x)
        output = self.fc(lstm_out[:, -1, :])  # Take the last output
        return output

def train_lstm(train_data, train_labels, input_size, hidden_size=64, epochs=50, lr=0.001):
    """
    Trains an LSTM model to predict evolutionary mutations.
    """
    model = EvolutionLSTM(input_size, hidden_size, output_size=1)
    criterion = nn.MSELoss()
    optimizer = optim.Adam(model.parameters(), lr=lr)

    for epoch in range(epochs):
        inputs = torch.tensor(train_data, dtype=torch.float32)
        labels = torch.tensor(train_labels, dtype=torch.float32)

        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs.squeeze(), labels)
        loss.backward()
        optimizer.step()

        if epoch % 10 == 0:
            print(f"Epoch {epoch}, Loss: {loss.item()}")

    return model

# ========================== STEP 3: BAYESIAN INFERENCE ==========================

def bayesian_mutation_estimate(dn_ds_values):
    """
    Uses Bayesian inference (Beta distribution) to estimate evolutionary mutation rates.
    """
    alpha = sum(dn_ds_values) + 1  # Prior counts
    beta_param = len(dn_ds_values) - sum(dn_ds_values) + 1  # Prior failures

    posterior = beta(alpha, beta_param)
    predicted_mutation_rate = posterior.mean()
    
    return predicted_mutation_rate

# ========================== RUN PREDICTION ==========================

def predict_future_evolution(alignment_file, dn_ds_file):
    """
    Main function: extracts features, trains LSTM, applies Bayesian inference, and predicts evolution.
    """
    # Step 1: Extract sequence features
    features = extract_features(alignment_file)

    # Step 2: Load dN/dS values for training
    df = pd.read_csv(dn_ds_file)
    labels = df["dN/dS"].values

    # Train LSTM model
    model = train_lstm(features, labels, input_size=features.shape[1])

    # Predict future mutations
    test_data = features[-1:].reshape(1, features.shape[1], 1)  # Last sequence for prediction
    test_tensor = torch.tensor(test_data, dtype=torch.float32)
    lstm_prediction = model(test_tensor).item()

    # Bayesian estimate
    bayesian_prediction = bayesian_mutation_estimate(labels)

    print(f"LSTM Predicted Mutation Rate: {lstm_prediction}")
    print(f"Bayesian Predicted Mutation Rate: {bayesian_prediction}")

    return lstm_prediction, bayesian_prediction

# ========================== EXECUTE ==========================

if __name__ == "__main__":
    predict_future_evolution("aligned_output.fasta", "dn_ds_values.csv")