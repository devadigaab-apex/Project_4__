#!/bin/bash

SHEET="gdc_sample_sheet.tsv"
TARFILE="tcga_data.tar.gz"
OUT="nkx2_1_expression.tsv"

if [[ -f "$TARFILE" ]]; then
    tar -zxvf "$TARFILE"
fi

echo -e "sample_id\tlabel\ttpm" > $OUT

tail -n +2 "$SHEET" | while IFS=$'\t' read -r FILE_ID FILE_NAME DATA_CATEGORY DATA_TYPE PROJECT_ID CASE_ID SAMPLE_ID SAMPLE_TYPE REST; do

    if [[ "$DATA_TYPE" != "Gene Expression Quantification" ]]; then
        continue
    fi

    if [[ "$SAMPLE_TYPE" == "Primary Tumor" ]]; then
        label="PTumor"
    elif [[ "$SAMPLE_TYPE" == "Solid Tissue Normal" ]]; then
        label="STNorm"
    else
        continue
    fi

    RNA_FILE=$(find "./$FILE_ID" -maxdepth 1 -name "*.rna_seq.augmented_star_gene_counts.tsv" 2>/dev/null | head -n 1)

    if [[ ! -f "$RNA_FILE" ]]; then
        echo "Warning: RNA-seq file missing for $FILE_ID"
        continue
    fi

    TPM=$(awk -F'\t' '$2=="NKX2-1"{print $7}' "$RNA_FILE")

    if [[ -z "$TPM" ]]; then
        echo "Warning: NKX2-1 not found in $RNA_FILE"
        continue
    fi

    echo -e "${SAMPLE_ID}\t${label}\t${TPM}" >> $OUT

done

echo "Output saved to: $OUT"

