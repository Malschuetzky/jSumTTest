---
output:
  html_document: default
  pdf_document: default
---
# jSumTTest
A [jamovi](https://www.jamovi.org/) (The jamovi project, 2025) module to calculate Student's and Welch's t-test for independent samples as well as one-sample t-test (including related Cohen's $d$) based on summary data (mean, standard deviation, and sample size) for both samples resp. one sample and test-value, if raw-data are not available.

**Current version:** 2.0.1

**Citation:** Malschützky, M. M. (2025). *jSumTTest: Independent Samples & One-Sample T-Test for Summary Data* (Version 2.0.1) [jamovi module]. https://github.com/Malschuetzky/jSumTTest

# 1 Intended use
## 1.1 Potential users
+ lecturers
+ students
+ reviewers
+ researchers
+ especially fellow psychologists &Psi; and higher ed researchers :mortar_board: using quantitative methods as well as all other stats-nerds...

We salute you :vulcan_salute:

## 1.2 Potential applications
Main application is to comprehend reported Student's, Welch's and one-sample t-test without access to raw-data.

By using reported samples' descriptives (mean $M$, standard deviation $SD$, and sample size $n$) the module calculates:
+ Additional sample descriptives:
  + Standard errors of sample mean $SE(M)$
  + Confidence intervals for sample mean $CI(M)$ of any witdh of your choice between 50 to 99.9% (default set to 95%)
+ One- and two-tailed test satistics for Student's, Welch's and one-sample t-tests:
  + $t$-value
  + $df$
  + $p$-value
  + Cohen's $d$
  + Confidence interval for Cohen's $d$, $CI(d)$, of any witdh of your choice between 50 to 99.9% (default set to 90%)
  + Mean-difference $\Delta M$
  + Standard error of mean-difference $SE(\Delta M)$
  + Confidence interval for mean-difference $CI(\Delta M)$ of any witdh of your choice between 50 to 99.9% (default set to 95%)
  
Additionaly, the module plots:
+ Mean and related CI for each sample in one graph
+ APA-style type tables for above calculated values

These additional values and plots not only supports to comprehend the reported test results and their interpretation. They also help to cope with improper use of statistical tests, e.g., calculating propper Welch's instead of a reported Student's t-test as the authors should have done right from the start (Kubinger et al., 2009; Zimmerman, 2004), or calculate missing effect sizes and confidcene intervals. They even help to identify fraudulent analyses, e.g., $p$-hacking where authors claim to use two-tailed tests in the method section but report one-tailed $p$-values in the result section instead. Fascinatingly, mostly happens if their two-sided $p$-value is between .09 and .05...

Users of psychometric tests can compare an observed sample with the normative data of the used test as well as check reported comparisons and even change the compared sub-sample of the normative data to their needs afterwards.

# 2. Installing jSumTTest

Latest version of jSumTTest is available via the jamovi library.

After installation you find the function named "Summary Data" in tab "T-Tests" under the new sub-menu "jSumTTest".

![Screenshot of the menu-path](readme_pics/readme_menu.png)

# 3. Analytical process

## 3.1 Select test version

The requested t-test can be selected by clicking on "Independent samples" or "One-sample" in the mode-selector "t-test type".

![Testselection in module menu](readme_pics/testselection.png)

As default, the "Independent samples" t-test is selected.

## 3.2 Additional sample descriptives

Independent from the selected test, the module calculates additional sample descriptives based on the required sample data in summarized form (sample size $n$, mean $M$, and standard deviation $SD$):

+ Calculate standard error of sample mean (Eid et al., 2017, F 8.4b): \
$$SE(M) = {SD \over \sqrt{n}}$$

+ Calculate confidence intervals for sample mean (Eid et al., 2017, F 8.26 resp. p. 303): \
$$CI(M) = M \pm (t(CI_{width};df) * SE(M))$$ \
using R function `qt()`to calculate $t$-value of degrees of freedom `df` and user chosen CI-width `CI_width` 
	```
	t(CI_width,df) = qt(p=CI_width, df=n-1)
	```
## 3.3 Independent samples test (if selected)

Based on required sample data in summarized form (sample size $n_i$, mean $M_i$, and standard deviation $SD_i$) for each of the two samples $i = [1; 2]$ to be compared, the module calculates Welch's t-test and Student's t-test. Optional, the samples can be named for more transparent graph and tables in the output.

### 3.3.1 Perform Welch's t-test
+ Calculate Welch's $t$-value (Eid et al., 2017, eq. F 11.11):\
$$t_{Welch} = {\Delta M \over SE_{Welch}(\Delta M)}$$ \
with mean-difference\
$$\Delta M = M_1 - M_2$$ \
and Welch-corrected standard error of means-difference\
$$SE_{Welch}(\Delta M) = \sqrt{{SD_1^2 \over n_1}+{SD_2^2 \over n_2}}$$

+ Calculate Welch-corrected degrees of freedom (Eid et al., 2017, eq. F 11.10):\
$$df_{Welch} = {{\left( {SD_1^2 \over n_1} + {SD_2^2 \over n_2} \right)^2} \over {{SD_1^4 \over n_1^2*(n_1-1)} + {SD_2^4 \over n_2^2*(n_2-1)}}} = {{SE_{Welch}(\Delta M)^4} \over {{SD_1^4 \over n_1^2*(n_1-1)} + {SD_2^4 \over n_2^2*(n_2-1)}}}$$

+ Calculate $p_{Welch}$-value using R funtion `pt()` for
	+ two-tailed hypothesis:
		```
		p_Welch <- 2*pt(q=abs(t_Welch), df=df_Welch, lower.tail=FALSE)
		```
	+ one-tailed hypothesis $M_1 > M_2$:
		```
		p_Welch <- pt(q=t_Welch, df=df_Welch, lower.tail=FALSE)
		```
	+ one-tailed hypothesis $M_1 < M_2$:
		```
		p_Welch <- pt(q=t_Welch, df=df_Welch, lower.tail=TRUE)
		```

+ Calculate effect size for unequal variances and equal sample sizes (Cohen, 1988, eq. 2.2.1, 2.2.2 & 2.3.2):\
$$d_{Welch} = {|\Delta M| \over \sqrt{ {SD_1^2 + SD_2^2 \over 2}}}$$

+ Calculate confidence interval for effect size $CI(d_{Welch})$ using psych R-package (Revelle, 2024) according to user chosen CI-width `CI_d_width`:
	```
	CI_d_Welch <- psych::d.ci(d_Welch, n1=n_1, n2=n_2, alpha=CI_d_width)
	CI_d_Welch_low <- CI_d_Welch[1]			# lower value
	CI_d_Welch_upp <- CI_d_Welch[3]			# upper value
	```

+ Calculate confidence interval for mean-difference for
	+ two-tailed hypothesis (Eid et al., 2017, eq. F 11.14a):\
$$CI_{Welch}(\Delta M) = \Delta M \pm t_{crit;two-tailed} * SE_{Welch}(\Delta M)$$
	+ one-tailed hypothesis $M_1 > M_2$ (Eid et al., 2017, eq. F 11.14b):\
$$CI_{Welch}(\Delta M) = [\Delta M - t_{crit;one-tailed} * SE_{Welch}(\Delta M); \infty]$$
	+ one-tailed hypothesis $M_1 < M_2$ (Eid et al., 2017, eq. F 11.14c):\
$$CI_{Welch}(\Delta M) = [-\infty ; \Delta M + t_{crit;one-tailed} * SE_{Welch}(\Delta M)]$$ \
with calculting $df_{Welch}$ related one- and two-tailed critical $t_{(crit;Welch)}$-value using R function `qt()` and user chosen CI-width `CI_deltaM_width_2tailed`for two-tailed hyothesis and respectively `CI_deltaM_width_1tailed`for one-tailed hyothesis:
		```
		t_crit_2tailed_Welch <- qt(p=CI_deltaM_width_2tailed, df=df_Welch)
		t_crit_1tailed_Welch <- qt(p=CI_deltaM_width_1tailed, df=df_Welch)
		```

### 3.3.2 Perform Student's t-test
+ Calculate Student's $t$-value (Eid et al., 2017, eq. F 11.9c):\
$$t_{Student} = {\Delta M \over SE_{Stud}(\Delta M)}$$ \
with mean-difference\
$$\Delta M = M_1 - M_2$$ \
and standard error of means-difference (Eid et al., 2017, eq. F 11.7)\
$$SE_{Student}= \sqrt{{\sigma_{pooled}^2 \over n_1}+{\sigma_{pooled}^2 \over n_2}}$$ \
using pooled variance (Eid et al., 2017, eq. F 11.8)\
$$\sigma_{pooled}^2 = {SD_1^2*(n_1-1)+SD_2^2*(n_2-1) \over (n_1-1)+(n_2-1)}$$

+ Calculate degrees of freedom (Eid et al., 2017, p. 334):\
$$df_{Student} = (n_1-1)+(n_2-1)$$

+ Calculate $p_{Student}$-value using R funtion `pt()` for
	+ two-tailed hypothesis:
		```
		p_Student <- 2*pt(q=abs(t_Student), df=df_Student, lower.tail=FALSE)
		```
	+ one-tailed hypothesis $M_1 > M_2$:
		```
		p_Student <- pt(q=t_Student, df=df_Student, lower.tail=FALSE)
		```
	+ one-tailed hypothesis $M_1 < M_2$:
		```
		p_Student <- pt(q=t_Student, df=df_Student, lower.tail=TRUE)
		```

+ Calculate effect size for Student's t-Test (Eid et al., 2017, eq. F 11.13b & Cohen, 1988, eq. 2.2.2):\
$$d_{Student} = {|\Delta M| \over SD_{pooled}} = {|\Delta M| \over \sqrt{\sigma_{pooled}^2}}$$

+ Calculate confidence interval for effect size $CI(d_{Student})$ using psych R-package (Revelle, 2024) according to user chosen CI-width `CI_d_width`:
  ```
  CI_d_Student <- psych::d.ci(d_Student, n1=n_1, n2=n_2, alpha=CI_d_width)
  CI_d_Student_low <- CI_d_Student[1]			# lower value
  CI_d_Student_upp <- CI_d_Student[3]			# upper value
  ```

+ Calculate confidence interval for mean-difference for
	+ two-tailed hypothesis (Eid et al., 2017, eq. F 11.14a):\
$$CI_{Student}(\Delta M) = \Delta M \pm t_{crit;two-tailed} * SE_{Student}(\Delta M)$$
	+ one-tailed hypothesis $M_1 > M_2$ (Eid et al., 2017, eq. F 11.14b):\
$$CI_{Student}(\Delta M) = [\Delta M - t_{crit;one-tailed} * SE_{Student}(\Delta M); \infty]$$
	+ one-tailed hypothesis $M_1 < M_2$ (Eid et al., 2017, eq. F 11.14c):\
$$CI_{Student}(\Delta M) = [-\infty ; \Delta M + t_{crit;one-tailed} * SE_{Student}(\Delta M)]$$ \
with calculting $df_{Student}$ related one- and two-tailed critical $t_{(crit;Student)}$-value using R function `qt()` and user chosen CI-width `CI_deltaM_width_2tailed`for two-tailed hyothesis and respectively `CI_deltaM_width_1tailed`for one-tailed hyothesis:
		```
		t_crit_2tailed_Student <- qt(p=CI_deltaM_width_2tailed, df=df_Student)
		t_crit_1tailed_Student <- qt(p=CI_deltaM_width_1tailed, df=df_Student)
		```
		
## 3.4 One-sample test-test (if selected)

Based on required sample data in summarized form (sample size $n$, mean $M$, and standard deviation $SD$) and the test value ($c$) to be compared, the module calculates the one-sample t-test.

+ Calculate degrees of freedom for sample (Cohen, 1988, p. 46; Eid et al., 2017, p. 255):\
$$df_{os} = {n-1}$$

+ Calculate $t$-value for one-sample t-test (Eid et al., 2017, eq. F 8.25):\
$$t_{os} = {\Delta M \over SE(M)}$$ \
with mean-difference\
$$\Delta M = M - c$$ \
and using the standard error of sample's mean as standard error of means-difference.
          
+ Calculate $p_{one-sample}$-value using R funtion `pt()` for
	+ two-tailed hypothesis:
		```
		p_os <- 2*pt(q=abs(t_os), df=df_os, lower.tail=FALSE)
		```
	+ one-tailed hypothesis $M > c$:
		```
		p_os <- pt(q=t_os, df=df_os, lower.tail=FALSE)
		```
	+ one-tailed hypothesis $M < c$:
		```
		p_os <- pt(q=t_os, df=df_os, lower.tail=TRUE)
		```
+ Calculate effect size for one-sample t-Test (Cohen, 1988, eq. 2.3.3):\
$$d_{os}^{\dagger} = {|\Delta M| \over SD}$$\
using the standard deviation of the sample.\
According to Cohen (1988, eq. 2.3.4), since the denominator only covers one sample, this value must be corrected by muliplying it by $\sqrt{2}$ to evaluate the effect using a standard threshold values:\
$$d_{os} = {d_{os}^{\dagger} * \sqrt{2}}$$\
Since many statistical tools and functions only display $d_{os}^{\dagger}$ as the effect size, both values are shown in the results table for consistency reasons.

+ Calculate confidence interval for effect size $CI(d_{os}^{\dagger})$ and $CI(d_{os})$ using psych R-package (Revelle, 2024) according to user chosen CI-width `CI_d_width` and sample size $n$:
  ```
  CI_d_os_dagger <- psych::d.ci(d_os_dagger, n1=n, alpha=CI_d_width)
  CI_d_os_dagger_low <- CI_d_os[1]			# lower value
  CI_d_os_dagger_upp <- CI_d_os[3]			# upper value
  CI_d_os <- psych::d.ci(d_os, n1=n, alpha=CI_d_width)
  CI_d_os_low <- CI_d_os_corr[1]			# lower value
  CI_d_os_upp <- CI_d_os_corr[3]			# upper value
  ```

+ Calculate confidence interval for mean-difference for
	+ two-tailed hypothesis (Eid et al., 2017, eq. F 11.14a):\
$$CI_{os}(\Delta M) = \Delta M \pm t_{crit;two-tailed} * SE(M)$$
	+ one-tailed hypothesis $M > c$ (Eid et al., 2017, eq. F 11.14b):\
$$CI_{os}(\Delta M) = [\Delta M - t_{crit;one-tailed} * SE(M); \infty]$$
	+ one-tailed hypothesis $M < c$ (Eid et al., 2017, eq. F 11.14c):\
$$CI_{os}(\Delta M) = [-\infty ; \Delta M + t_{crit;one-tailed} * SE(M)]$$ \
with calculting $df_{os}$ related one- and two-tailed critical $t_{(crit;os)}$-value using R function `qt()` and user chosen CI-width `CI_deltaM_width_2tailed`for two-tailed hyothesis and respectively `CI_deltaM_width_1tailed`for one-tailed hyothesis:
		```
		t_crit_2tailed_os <- qt(p=CI_deltaM_width_2tailed, df=df_os)
		t_crit_1tailed_os <- qt(p=CI_deltaM_width_1tailed, df=df_os)
		```

# 4. Contributing

We encourage you to send bug reports, suggestions, questions, or any other comment you want us to know.


# References
Cohen, J. (1988). *Statistical power analysis for the behavioral sciences* (2nd ed). L. Erlbaum Associates.

Eid, M., Gollwitzer, M., & Schmitt, M. (2017). *Statistik und Forschungsmethoden* (5., korrigierte Auflage). Beltz.

Kubinger, K. D., Rasch, D., & Moder, K. (2009). Zur Legende der Voraussetzungen des t-Tests für unabhängige Stichproben. *Psychologische Rundschau*, 60(1), 26–27. https://doi.org/10.1026/0033-3042.60.1.26

R Core Team. (2025). *R: A Language and Environment for Statistical Computing* (Version 4.5.2) [Computer Software]. R Foundation for Statistical Computing. https://www.R-project.org/

Revelle, W. (2025). *psych: Procedures for Psychological, Psychometric, and Personality Research* (Version 2.5.6) [R package]. https://cran.r-project.org/web/packages/psych/index.html

The jamovi project. (2025). *jamovi* (Version 2.7.12.0) [Computer Software]. https://www.jamovi.org

Wickham, H., Chang, W., Henry, L., Pedersen, T. L., Takahashi, K., Wilke, C., Woo, K., Yutani, H., Dunnington, D., & van den Brand, T. (2025). *ggplot2: Create Elegant Data Visualisations Using the Grammar of Graphics* (Version 4.0.1) [R package]. Posit, PBC. https://cran.r-project.org/package=ggplot2

Zimmerman, D. W. (2004). A note on preliminary tests of equality of variances. *British Journal of Mathematical and Statistical Psychology*, 57(1), 173–181. https://doi.org/10.1348/000711004849222

<sub>(References used in code for analytical process can also be found in the comments of the code-files)</sub>
