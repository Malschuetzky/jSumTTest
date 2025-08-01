# jSumTTest
A [jamovi](https://www.jamovi.org/) (The jamovi project, 2025) module to calculate Student's and Welch's t-test (including related Cohen's $d$) based on summary data (mean, standard deviation, and sample size) for both groups, if raw-data are not available.

**Current version:** 1.2.0

**Citation:** Malschützky, M. M. (2025). *jSumTTest: Independent Samples Test for Summary Data* (Version 1.2.0) [Jamovi module]. https://github.com/Malschuetzky/jSumTTest

# 1 Intended use
## 1.1 Potential users
+ lecturers
+ students
+ reviewers
+ researchers
+ especially fellow psychologists &Psi; and higher ed researchers :mortar_board: using quantitative methods as well as all other stats-nerds...

We salute you :vulcan_salute:

## 1.2 Potential applications
Main application is to comprehend reported Student's and Welch's t-test without access to raw-data.

By using reported groups' descriptives (mean $M$, standard deviation $SD$, and sample size $n$) the module calculates:
+ Additional group descriptives:
  + Standard errors of group means $SE(M)$
  + Convidence intervals for group means $CI(M)$ of any witdh of your choice between 50 to 99.9% (default set to 95%)
+ One- and two-tailed test satistics for Student's and Welch's t-tests:
  + $t$-value
  + $df$
  + $p$-value
  + Cohen's $d$
  + Convidence interval for Cohen's $d$, $CI(d)$, of any witdh of your choice between 50 to 99.9% (default set to 95%)
  + Mean-difference $\Delta M$
  + Standard error of mean-difference $SE(\Delta M)$
  + Convidence interval for mean-difference $CI(\Delta M)$ of any witdh of your choice between 50 to 99.9% (default set to 95%)
  
Additionaly, the module plots:
+ Mean and related CI for each group in one graph
+ APA-style type tables for above calculated values

These additional values and plots not only supports to comprehend the reported test results and their interpretation. They also help to cope with improper use of statistical tests, e.g., calculating propper Welch's instead of a reported Student's t-test as the authors should have done right from the start (Kubinger et al., 2009; Zimmerman, 2004), or calculate missing effect sizes. They even help to identify fraudulent analyses, e.g., $p$-hacking where authors claim to use two-tailed tests in the method section but report one-tailed $p$-values in the result section instead. Fascinatingly, mostly happens if their two-sided $p$-value is between .09 and .05...

Users of psychometric tests can compare an observed group with the normative data of the used test as well as check reported comparisons and even change the compared sub-group of the normative data to their needs afterwards.

# 2. Installing jSumTTest

Latest version of jSumTTest is available via the jamovi library.

After installation you find the function named "Summary Data" in tab "T-Tests" under the new sub-menu "jSumTTest".

![Screenshot of the menu-path](readme_pics/readme_menu.png)

# 3. Analytical process

Based on required group data in summarized form (sample size $n_i$, mean $M_i$, and standard deviation $SD_i$) for each of the two groups $i = [1; 2]$ to be compared, the module will calculate additional group descriptives, Welch's t-test, and Student's t-test. Optional, the groups can be named to for more transparent graph and tables in the output.

## 3.1 Calculate additional descriptives
+ Calculate standard errors of group means (Eid et al., 2017, F 8.4b): \
$$SE(M_i) = {SD_i \over \sqrt{n_i}}$$

+ Calculate convidence intervals for group means (Eid et al., 2017, F 8.16): \
$$CI(M_i) = M_i \pm (Z(CI_{width}) * SE(M_i))$$ \
using R function `qnorm()`to calculate $z$-value of user chosen CI-width `CI_width`
	```
	z(CI_widht) = qnorm(CI_width)
	```

## 3.2 Perform Welch's t-test
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

+ Calculate effect size for unequal variances and equal group sizes (Cohen, 1988, eq. 2.2.1, 2.2.2 & 2.3.2):\
$$d_{Welch} = {|\Delta M| \over \sqrt{ {SD_1^2 + SD_2^2 \over 2}}}$$

+ Calculate convidence interval for effect size $CI(d_{Welch})$ using psych R-package (Revelle, 2024) according to user chosen CI-width `CI_d_width`:
	````
	CI_d_Welch <- psych::d.ci(d_Welch, n1=n_1, n2=n_2, alpha=CI_d_width)
	CI_d_Welch_low <- CI_d_Welch[1]			# lower value
	CI_d_Welch_upp <- CI_d_Welch[3]			# upper value
	 ````

+ Calculate convidence interval for mean-difference for
	+ two-tailed hypothesis (Eid et al., 2017, eq. F 11.14a):\
$$CI_{Welch}(\Delta M) = \Delta M \pm t_{crit, two-tailed} * SE_{Welch}(\Delta M)$$
	+ one-tailed hypothesis $M_1 > M_2$ (Eid et al., 2017, eq. F 11.14b):\
$$CI_{Welch}(\Delta M) = [\Delta M - t_{crit, one-tailed} * SE_{Welch}(\Delta M); \infty]$$
	+ one-tailed hypothesis $M_1 < M_2$ (Eid et al., 2017, eq. F 11.14c):\
$$CI_{Welch}(\Delta M) = [-\infty ; \Delta M + t_{crit, one-tailed} * SE_{Welch}(\Delta M)]$$ \
with calculting $df_{Welch}$ related one- and two-tailed critical $t_{(crit,Welch)}$-value using R function `qt()` and user chosen CI-width `CI_deltaM_width_2tailed`for two-tailed hyothesis and respectively `CI_deltaM_width_1tailed`for one-tailed hyothesis:
		```
		t_crit_2tailed_Welch <- qt(CI_deltaM_width_2tailed,df_Welch)
		t_crit_1tailed_Welch <- qt(CI_deltaM_width_1tailed,df_Welch)
		```


## 3.3 Perform Student's t-test
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

+ Calculate convidence interval for effect size $CI(d_{Student})$ using psych R-package (Revelle, 2024) according to user chosen CI-width `CI_d_width`:
	````
	CI_d_Student <- psych::d.ci(d_Student, n1=n_1, n2=n_2, alpha=CI_d_width)
	CI_d_Student_low <- CI_d_Student[1]			# lower value
	CI_d_Student_upp <- CI_d_Student[3]			# upper value
	 ````

+ Calculate convidence interval for mean-difference for
	+ two-tailed hypothesis (Eid et al., 2017, eq. F 11.14a):\
$$CI_{Student}(\Delta M) = \Delta M \pm t_{crit, two-tailed} * SE_{Student}(\Delta M)$$
	+ one-tailed hypothesis $M_1 > M_2$ (Eid et al., 2017, eq. F 11.14b):\
$$CI_{Student}(\Delta M) = [\Delta M - t_{crit, one-tailed} * SE_{Student}(\Delta M); \infty]$$
	+ one-tailed hypothesis $M_1 < M_2$ (Eid et al., 2017, eq. F 11.14c):\
$$CI_{Student}(\Delta M) = [-\infty ; \Delta M + t_{crit, one-tailed} * SE_{Student}(\Delta M)]$$ \
with calculting $df_{Student}$ related one- and two-tailed critical $t_{(crit,Student)}$-value using R function `qt()` and user chosen CI-width `CI_deltaM_width_2tailed`for two-tailed hyothesis and respectively `CI_deltaM_width_1tailed`for one-tailed hyothesis:
		```
		t_crit_2tailed_Student <- qt(CI_deltaM_width_2tailed,df_Student)
		t_crit_1tailed_Student <- qt(CI_deltaM_width_1tailed,df_Student)
		```
	
		  
# 4. Contributing

We encourage you to send bug reports, suggestions, questions, or any other comment you want us to know.


# References
Cohen, J. (1988). *Statistical power analysis for the behavioral sciences* (2nd ed). L. Erlbaum Associates.

Eid, M., Gollwitzer, M., & Schmitt, M. (2017). *Statistik und Forschungsmethoden* (5., korrigierte Auflage). Beltz.

Kubinger, K. D., Rasch, D., & Moder, K. (2009). Zur Legende der Voraussetzungen des t-Tests für unabhängige Stichproben. *Psychologische Rundschau*, 60(1), 26–27. https://doi.org/10.1026/0033-3042.60.1.26

R Core Team. (2025). *R: A Language and Environment for Statistical Computing* (Version 4.5.0) [Computer Software]. R Foundation for Statistical Computing. https://www.R-project.org/

Revelle, W. (2025). *psych: Procedures for Psychological, Psychometric, and Personality Research* (Version 2.5.3) [R package]. https://cran.r-project.org/web/packages/psych/index.html

The jamovi project. (2025). *jamovi* (Version 2.6.44.0) [Computer Software]. https://www.jamovi.org

Wickham, H., Chang, W., Henry, L., Pedersen, T. L., Takahashi, K., Wilke, C., Woo, K., Yutani, H., Dunnington, D., & van den Brand, T. (2024). *ggplot2: Create Elegant Data Visualisations Using the Grammar of Graphics* (Version 3.5.2) [R package]. Posit, PBC. https://cran.r-project.org/package=ggplot2

Zimmerman, D. W. (2004). A note on preliminary tests of equality of variances. *British Journal of Mathematical and Statistical Psychology*, 57(1), 173–181. https://doi.org/10.1348/000711004849222

<sub>(References used in code for analytical process can also be found in the comments of the code-files)</sub>