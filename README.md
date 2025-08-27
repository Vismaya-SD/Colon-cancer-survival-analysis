# Analysis of Colon Cancer Survival Data: Treatment Efficacy and Subgroup Identification

[![View Live Report](https://img.shields.io/badge/View-Live%20Report-brightgreen)](https://vismaya-sd.github.io/Colon-cancer-survival-analysis/docs/index.html)

[![Language](https://img.shields.io/badge/language-R-blue)](https://www.r-project.org/)
[![Analysis](https://img.shields.io/badge/analysis-survival-green)](https://en.wikipedia.org/wiki/Survival_analysis)

A biostatistics project analyzing survival data to evaluate treatment efficacy and identify key patient subgroups in colon cancer. The final report is hosted live using GitHub Pages.

---

## 🚀 View the Live Report

The full interactive HTML report is hosted online.

**[➡️ Click here to view the Live Report](https://your-username.github.io/your-repository-name/Treatment-Efficacy.html)**

---

## 📖 Overview

This repository contains the analysis and findings for the project, "Analysis of Colon Cancer Survival Data: Treatment Efficacy and Subgroup Identification." The primary goal of this analysis is to explore a colon cancer dataset to understand the effectiveness of different treatments on patient survival.

The project employs several key statistical methods to not only compare treatment arms but also to identify specific patient subgroups that may respond differently to therapy. The full, reproducible analysis is documented in the R Markdown file.

---

## 📊 Key Analyses & Methods

The following statistical methods were central to this analysis:

* **Kaplan-Meier Analysis:** To estimate and visualize survival curves.
* **Log-Rank Test:** To formally test for significant differences in survival distributions.
* **Cox Proportional Hazards Models:** To perform multivariate survival analysis, assessing the impact of treatments while controlling for other important covariates.
* **Subgroup Analysis:** To investigate treatment effects within specific patient strata.

---

## 📁 Repository Contents

* `Treatment-Efficacy.html`: The final HTML report (also the source for the live site).
* `Treatment Efficacy.Rmd`: The complete R Markdown source code for full reproducibility.
* `Treatment Efficacy.R`: The complete R-Script source code for full reproducibility.
* `[style.css]`: The style used in the report.
  

---

## 🔧 How to Reproduce this Analysis

To run this analysis on your own machine, please follow these steps:

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/your-username/your-repository-name.git](https://github.com/your-username/your-repository-name.git)
    cd your-repository-name
    ```

2.  **Prerequisites:**
    * Ensure you have [R](https://www.r-project.org/) and [RStudio Desktop](https://posit.co/download/rstudio-desktop/) installed.
    * Install the necessary R packages by running this command in your R console:
        ```R
        install.packages(c("survival", "survminer", "ggplot2", "dplyr"))
        ```

3.  **Run the Analysis:**
    * Open the `analysis.Rmd` file in RStudio.
    * Click the "Knit" button to execute the code and regenerate the `Treatment-Efficacy.html` report.

---

### Author

* **Vismaya S D** | MSc Biostatistics | Manipal Academy of Higher Education
