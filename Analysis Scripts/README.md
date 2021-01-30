# Benzimidazole Descriptor Trend Analysis

- The `SAR_CSVmaker.py` Python script uses the RDKit package to compute molecular descriptors on a CSV file filled with SMILES fragments and wraps all descriptors into a single overall CSV file.
- The `Trend_Lipinski_Analysis.R` script uses ggplot2 to generate scatterplots showing the association between descriptors and docking score. This script also has a section which uses dplyr to filter all molecules which satisfy Lipinski's Rule of 5 and writes all matching molecules to a CSV file.

Please acknowledge the following packages alongside with the primary citation of this paper:

- RDKit: Open-source cheminformatics;[ ](http://www.rdkit.org/)http://www.rdkit.org

- Wickham H (2016). *ggplot2: Elegant Graphics for Data Analysis*. Springer-Verlag New York. ISBN 978-3-319-24277-4, https://ggplot2.tidyverse.org. 

