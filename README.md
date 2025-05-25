# jSumTTest

A [jamovi](https://www.jamovi.org/) module to calculate Student's and Welch's t-test (including related Cohen's *d*) based on summary data (mean, standard deviation, and sample size) for both groups, if raw-data are not available.

Current version: 1.0.1

# Intended use

## User-groups

+ lecturers
+ students
+ reviewers
+ researchers
+ fellow psychologists &Psi; and higher ed researchers using quantitative methods
+ all other stats-neards... We salute you :vulcan_salute:

## Applications

Main application is to comprehend reported Student's and Welch's t-test without access to raw-data.

By using reported group descriptives (mean (*M*), standard deviation (*SD*), and sample size(*n*) the module calculates:

+ Additional group descriptives:
  + Standard errors of group means (*SE*(*M*))
  + Convidence intervals for group means (*CI*(*SE*(*M*))) of any witdh of your choice between 50 to 99.9% (default set to 95%)
+ One- and two-tailed test satistics for Student's and Welch's t-tests:
  + *t*-value
  + *df*
  + *p*-value
  + Cohen's *d*
  + Convidence interval for Cohen's *d* (*CI*(*d*)) of any witdh of your choice between 50 to 99.9% (default set to 95%)
  + Mean difference (&Delta;*M*)
  + Standard error of mean-difference (*SE*(&Delta;*M*))
  + Convidence interval for mean-difference (*CI*(*SE*(&Delta;*M*))) of any witdh of your choice between 50 to 99.9% (default set to 95%)
  
Additionaly, the module plots:
+ Mean and related CI for each group in one graph
+ APA-style type tables for above calculated values




 to judge the reported tests, calcutlate Welch's t-test check for improper or fraudulent analyses.

# Installing jSumTTest

Currently only available via sideload. Build module for Windows can be found here :file_folder:: [DOWNLOAD](jSumTTest_1.0.1.jmo)

After installation you find the function as "Independent Samples Test for Summary Data" in tab "T-Tests" under the new sub-menu "Test for Summary Data [jSumTTest module]".

# Analytical process

Sources for in R-code used packages and statistical formulas are mentioned below and in the comments of the code-files.

# Contributing

We encourage you to send bug reports, suggestions, questions, or any other comment you want us to know.

# To-do's

+ Add toggle switch to change between d-values
+ Add options to fancy-up graph plot

# References (also available in the comments of the code-files)

Cohen, J. (1988). *Statistical power analysis for the behavioral sciences* (2nd ed). L. Erlbaum Associates.

Eid, M., Gollwitzer, M., & Schmitt, M. (2017). *Statistik und Forschungsmethoden* (5., korrigierte Auflage). Beltz.

R Core Team. (2024). *R: A Language and Environment for Statistical Computing* (Version 4.4.1) [Computer Software]. R Foundation for Statistical Computing. https://www.R-project.org/

Revelle, W. (2024). *psych: Procedures for Psychological, Psychometric, and Personality Research* (Version 2.4.6.26) [R package]. https://cran.r-project.org/web/packages/psych/index.html

Wickham, H., Chang, W., Henry, L., Pedersen, T. L., Takahashi, K., Wilke, C., Woo, K., Yutani, H., Dunnington, D., & van den Brand, T. (2024). *ggplot2: Create Elegant Data Visualisations Using the Grammar of Graphics* (Version 3.5.1) [R package]. Posit, PBC. https://cran.r-project.org/package=ggplot2