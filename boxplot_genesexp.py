import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv("nkx2_1_expression.tsv", sep="\t")

# Compute log2(TPM + 1)
df["log2_tpm"] = np.log2(df["tpm"] + 1)

# Map to assignment labels
df["label"] = df["label"].map({"PTumor": "PT", "STNorm": "STN"})

# Create boxplot
plt.figure(figsize=(7, 5))
df.boxplot(column="log2_tpm", by="label")

plt.title("NKX2-1 Expression (log₂(TPM+1))")
plt.suptitle("")  # remove pandas default title

plt.xlabel("Condition")
plt.ylabel("log₂(TPM + 1)")
plt.grid(axis='y', linestyle='--', alpha=0.5)

plt.tight_layout()
plt.savefig("nkx2_1_boxplot_log2.png", dpi=300)
plt.show()

