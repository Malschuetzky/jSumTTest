# jSumTTest
A [jamovi](https://www.jamovi.org/) module to calculate Student's and Welch's t-test (including related Cohen's *d*) based on summary data (mean, standard deviation, and sample size) for both groups, if raw-data are not available.

**Current version:** 1.0.1

**Citation:** Malschützky, M. M. (2024). *jSumTTest: Independent Samples Test for Summary Data* (Version 1.0.1) [Jamovi module]. https://github.com/Malschuetzky/jSumTTest

# Intended use
## Potential users
+ lecturers
+ students
+ reviewers
+ researchers
+ fellow psychologists &Psi; and higher ed researchers :mortar_board: using quantitative methods as well as all other stats-nerds...

We salute you :vulcan_salute:

## Potential applications
Main application is to comprehend reported Student's and Welch's t-test without access to raw-data.

By using reported group descriptives (mean (*M*), standard deviation (*SD*), and sample size (*n*) the module calculates:
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

These additional values and plots not only supports to comprehend the reported test results and their interpretation. They also help to cope with improper use of statistical tests, e.g., calculating propper Welch's instead of a reported Student's t-test as the authors should have done right from the start (Kubinger et al., 2009; Zimmerman, 2004), or calculate missing effect sizes. They even help to identify fraudulent analyses, e.g., *p*-hacking where authors claim to use two-tailed tests in the method section but report one-tailed *p*-values in the result section instead. Fascinatingly, mostly happens if their two-sided *p*-value is between .09 and .05...

Users of psychometric tests can compare an observed group with the normative data of the used test as well as check reported comparisons and even change the compared sub-group of the normative data to their needs afterwards.

# Installing jSumTTest

Currently only available via sideload. Built module for MS-Windows can be found here :file_folder:: [DOWNLOAD](jSumTTest_1.0.1.jmo)

After installation you find the function named "Independent Samples Test for Summary Data" in tab "T-Tests" under the new sub-menu "Test for Summary Data [jSumTTest module]".

# Analytical process

Sources for in R-code used packages and statistical formulas are mentioned below and in the comments of the code-files.

# Contributing

We encourage you to send bug reports, suggestions, questions, or any other comment you want us to know.

# To-do's

+ README:
  + Add details for the analytical process with used formulas
+ Module:  
  + Add toggle switch to change between different formulas for Cohen's *d*
  + Build module for macOS
  + Add options to fancy-up graph plot

# References
Cohen, J. (1988). *Statistical power analysis for the behavioral sciences* (2nd ed). L. Erlbaum Associates.

Eid, M., Gollwitzer, M., & Schmitt, M. (2017). *Statistik und Forschungsmethoden* (5., korrigierte Auflage). Beltz.

Kubinger, K. D., Rasch, D., & Moder, K. (2009). Zur Legende der Voraussetzungen des t-Tests für unabhängige Stichproben. *Psychologische Rundschau*, 60(1), 26–27. https://doi.org/10.1026/0033-3042.60.1.26

R Core Team. (2024). *R: A Language and Environment for Statistical Computing* (Version 4.4.1) [Computer Software]. R Foundation for Statistical Computing. https://www.R-project.org/

Revelle, W. (2024). *psych: Procedures for Psychological, Psychometric, and Personality Research* (Version 2.4.6.26) [R package]. https://cran.r-project.org/web/packages/psych/index.html

Wickham, H., Chang, W., Henry, L., Pedersen, T. L., Takahashi, K., Wilke, C., Woo, K., Yutani, H., Dunnington, D., & van den Brand, T. (2024). *ggplot2: Create Elegant Data Visualisations Using the Grammar of Graphics* (Version 3.5.1) [R package]. Posit, PBC. https://cran.r-project.org/package=ggplot2

Zimmerman, D. W. (2004). A note on preliminary tests of equality of variances. *British Journal of Mathematical and Statistical Psychology*, 57(1), 173–181. https://doi.org/10.1348/000711004849222

<sub>(References used in code for analytical process can also be found in the comments of the code-files)</sub>