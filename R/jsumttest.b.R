jSumTTestClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "jSumTTestClass",
    inherit = jSumTTestBase,
    private = list(
    # VERSION 2.0.1 - 2025-11-16
      
      .init=function() {
        
        ## common options read into local variables
        testselect <- self$options$testselect
        CI_M_W_GUI <- self$options$CI_M_width     # value in %
        SE_M_cb <- self$options$SE_M_show
        CI_M_cb <- self$options$CI_M_show

        ## pointer to result objects
        # independent samples
        table_tests <- self$results$ttesttable # test-values independent samples
        table_descriptives <- self$results$desctable	# descriptive values independent samples
        # one-sample
        table_tests_os <- self$results$ttesttable_os # test-values one-sample
        table_descriptives_os <- self$results$desctable_os # descriptive values one-sample
        # plot
        desc_plot <- self$results$plot
        
        ## prepare SuperTitles for tables
        # CI(M) SuperTitle
        CI_M_h <- jmvcore::format('{}% CI(M)', CI_M_W_GUI)
        # CI(d) SuperTitle for independent samples and corrected one-sample effect
        CI_d_h <- jmvcore::format('{}% CI(d)', self$options$CI_d_width)
        # CI(d*) SuperTitle for one-sample
        CI_d_os_h <- jmvcore::format('{}% CI(d<sup>~</sup>)', self$options$CI_d_width)
        # CI(mean difference) SuperTitle
        CI_deltaM_h <- jmvcore::format('{}% CI(&Delta;M)', self$options$CI_deltaM_width)
        
        ## set SuperTitles and footnote in tables based on test selection                    
        if (testselect == 'ttest_is') {     # independent samples selected
          # set SuperTitles in both tables
          table_descriptives$getColumn('CI_M_low')$setSuperTitle(CI_M_h)
          table_descriptives$getColumn('CI_M_upp')$setSuperTitle(CI_M_h)
          
          table_tests$getColumn('CI_d_low')$setSuperTitle(CI_d_h)
          table_tests$getColumn('CI_d_upp')$setSuperTitle(CI_d_h)
          
          table_tests$getColumn('CI_deltaM_low')$setSuperTitle(CI_deltaM_h)
          table_tests$getColumn('CI_deltaM_upp')$setSuperTitle(CI_deltaM_h)
          
          # set test-table footnote based on hypothesis
          hypo_tail_is <- self$options$hypo
          
          if (hypo_tail_is == 'notequal') {
            hypo_text_is <- 'H<sub>a</sub>: μ<sub>1</sub> &#8800 μ<sub>2</sub>.'   # two-tailed test (M1 != M2)
            table_tests$setNote('1',hypo_text_is, init=TRUE)            
          } else if (hypo_tail_is == 'onegreater') {
            hypo_text_is <- 'H<sub>a</sub>: μ<sub>1</sub> > μ<sub>2</sub>.'  # one-tailed test (M1 > M2)
            table_tests$setNote('1',hypo_text_is, init=TRUE)
          } else if (hypo_tail_is == 'twogreater') {
            hypo_text_is <- 'H<sub>a</sub>: μ<sub>1</sub> < μ<sub>2</sub>.'    # one-tailed test (M1 < M2)
            table_tests$setNote('1',hypo_text_is, init=TRUE)
          } else {     # error-mode
            table_tests$setError('init function error: hypothesis selection independent samples')
          }
          
        } else if (testselect == 'ttest_os') {     # one-sample selected
#          pop_var_os <- self$options$pop_var
          
          # set SuperTitles in both tables
          table_descriptives_os$getColumn('CI_M_low')$setSuperTitle(CI_M_h)
          table_descriptives_os$getColumn('CI_M_upp')$setSuperTitle(CI_M_h)
          
          table_tests_os$getColumn('CI_d_low')$setSuperTitle(CI_d_os_h)
          table_tests_os$getColumn('CI_d_upp')$setSuperTitle(CI_d_os_h)
          
          table_tests_os$getColumn('CI_d_corr_low')$setSuperTitle(CI_d_h)
          table_tests_os$getColumn('CI_d_corr_upp')$setSuperTitle(CI_d_h)
          
          table_tests_os$getColumn('CI_deltaM_low')$setSuperTitle(CI_deltaM_h)
          table_tests_os$getColumn('CI_deltaM_upp')$setSuperTitle(CI_deltaM_h)
          
          # set test-table footnote based on hypothesis
          hypo_tail_os <- self$options$hypo_os
          effect_cb <- self$options$d_show
          if (effect_cb==TRUE) {
#            Cohen_os <- ' Cohen&apos;s <i>d</i> = <i>d</i><sup>~</sup>&Sqrt;(2) allows usage of standard threshold values and tables without correction.'
            Cohen_os <- ' Cohen&apos;s <i>d</i> = <i>d</i><sup>~</sup>&Sqrt;(2) allows usage of standard threshold values and tables without correction.'
          } else {
            Cohen_os <- ''
          }
          
          if (hypo_tail_os == 'notequal_os') {
#            hypo_text_os <- jmvcore::format('H<sub>a</sub>: μ &#8800 <i>c</i>. {variance} population variance.{effect}', variance=pop_var_os, effect=Cohen_os)   # two-tailed test (M != c)
            hypo_text_os <- jmvcore::format('H<sub>a</sub>: μ &#8800 <i>c</i>.{effect}', effect=Cohen_os)   # two-tailed test (M != c)
            table_tests_os$setNote('1',hypo_text_os, init=TRUE)
          } else if (hypo_tail_os == 'onegreater_os') {
#            hypo_text_os <- jmvcore::format('H<sub>a</sub>: μ > <i>c</i>. {variance} population variance.{effect}', variance=pop_var_os, effect=Cohen_os)  # one-tailed test (M > c)
            hypo_text_os <- jmvcore::format('H<sub>a</sub>: μ > <i>c</i>.{effect}', effect=Cohen_os)  # one-tailed test (M > c)
            table_tests_os$setNote('1',hypo_text_os, init=TRUE)
          } else if (hypo_tail_os == 'twogreater_os') {
#            hypo_text_os <- jmvcore::format('H<sub>a</sub>: μ < <i>c</i>. {variance} population variance.{effect}', variance=pop_var_os, effect=Cohen_os)  # one-tailed test (M < c)
            hypo_text_os <- jmvcore::format('H<sub>a</sub>: μ < <i>c</i>.{effect}.', effect=Cohen_os)  # one-tailed test (M < c)
            table_tests_os$setNote('1',hypo_text_os, init=TRUE)
          } else {     # error-mode
            table_tests_os$setError('init function error: hypothesis selection one-sample')
          }
          
#          if ( SE_M_cb==TRUE || CI_M_cb==TRUE) {
#            table_descriptives_os_text <- jmvcore::format('<i>SE</i>(<i>M</i>) and {width}% <i>CI</i>(<i>M</i>) based on {variance} population variance.', width=CI_M_W_GUI, variance=pop_var_os)
#            table_descriptives_os$setNote('1',table_descriptives_os_text, init=TRUE)
#          } else {
#            table_descriptives_os$setNote(key = "1", note = NULL)
#          }

        } else {     # error-mode
          #table_tests$setNote('1','init function error: test selection', init=TRUE) 
          #table_tests_os$setNote('1','init function error: test selection', init=TRUE)
          table_tests$setError('init function error: test selection')
          table_tests_os$setError('init function error: test selection')
          
          table_descriptives$setError('init function error: test selection')
          table_descriptives_os$setError('init function error: test selection')
        }
        
        
        ## set plot title
        plot_h <- jmvcore::format('Descriptives Plot (mean and {}% CI)', CI_M_W_GUI)
        desc_plot$setTitle(plot_h)
        
      },
      
      
        .run = function() {
          
          # `self$data` contains the data             no data objects in this module
          # `self$options` contains the options       will here also be used to read in summary data
          # `self$results` contains the results object (to populate)

          #### UI read into local variables ####
          testselect <- self$options$testselect
          
          ### summary data
          
          ## independent samples t-test variables
		      # Sample 1 data
          n1 <- self$options$n1
          M1 <- self$options$M1
          SD1 <- self$options$SD1
          G1_name <- self$options$name1
          
		      # Sample 2 data
          n2 <- self$options$n2
          M2 <- self$options$M2
          SD2 <- self$options$SD2
          G2_name <- self$options$name2		  

          # Hypthesis tail and direction 
          hypo_tail_is <- self$options$hypo
          
          
          ## one-sample t-test variables
          # sample data
          n_os <- self$options$n_os
          M_os <- self$options$M_os
          SD_os <- self$options$SD_os
#          pop_var_os <- self$options$pop_var
          
          # test value
          tv_os <- self$options$testvalue_os
          
          # Hypthesis tail and direction 
          hypo_tail_os <- self$options$hypo_os          
          
          
          ### Common options read into local variables and related calculations
          ## independent samples t-test variables
          # Confidence Interval width for means-difference in test-values-table
          CI_deltaM_Wd_1s <- self$options$CI_deltaM_width/100 # calculate decimal value, also one-tailed decimal value
          CI_deltaM_Wd_2s <- CI_deltaM_Wd_1s+((1-CI_deltaM_Wd_1s)/2) # calculate two-tailed decimal value

		      # Confidence Interval width for means in descriptives-values-table
          CI_M_W_GUI <- self$options$CI_M_width/100     # as decimal value
          CI_M_W <- CI_M_W_GUI+((1-CI_M_W_GUI)/2)       # as CI(M) is always two-tailed
          
		      # Confidence Interval width for Cohen's d effect-size
          CI_d <- 1-(self$options$CI_d_width/100)

          
          ### pointer to result objects
          # independent samples
          table_tests <- self$results$ttesttable # test-values independent samples
          table_descriptives <- self$results$desctable	# descriptive values independent samples
          desc_plot <- self$results$plot
          # one-sample
          table_tests_os <- self$results$ttesttable_os # test-values one-sample
          table_descriptives_os <- self$results$desctable_os # descriptive values one-sample

          
          #### calculate descriptives ####
          ## calculate mean difference
          # independent samples
          M_diff <- M1-M2
          # one-sample
          M_diff_os <- M_os-tv_os
          
          ## calculate standard errors of means (Eid et al., 2017, F 8.23)
          # independent samples
          SE_M1 <- SD1/sqrt(n1-1)     # for unkown population variance
          SE_M2 <- SD2/sqrt(n2-1)
          # one-sample
#          if (pop_var_os == 'known') {
            SE_M_os <- SD_os/sqrt(n_os)           # for kown population variance
#          } else if (pop_var_os == 'unknown') {
#            SE_M_os <- SD_os/sqrt(n_os-1)         # for unkown population variance
#          } else {    # error-mode
#            SE_M_os <- NaN
#            table_tests_os$setError('calculation SE(M) error: variance status selection one-sample')            
#            table_descriptives_os$setError('calculation SE(M) error: variance status selection one-sample')
#          }

          ### calculate Convidence Interval for means
          ## calculate t-values of given CI width
          # independent samples
          t_CI_value_M1 <- qt(p=CI_M_W, df=n1-1)
          t_CI_value_M2 <- qt(p=CI_M_W, df=n2-1)
          # one-sample
          t_CI_value_M_os <- qt(p=CI_M_W, df=n_os-1)          
          
          # calculate CI boarders (Eid et al., 2017, F 8.26)
          # independent samples
          CI_M1_err <- t_CI_value_M1*SE_M1
          CI_M1_low <- M1-CI_M1_err
          CI_M1_upp <- M1+CI_M1_err
		  
          CI_M2_err <- t_CI_value_M2*SE_M2
          CI_M2_low <- M2-CI_M2_err
          CI_M2_upp <- M2+CI_M2_err
          
          # one-sample (Eid et al., 2017, p. 303)
          CI_M_os_err <- t_CI_value_M_os*SE_M_os
          CI_M_os_low <- M_os-CI_M_os_err
          CI_M_os_upp <- M_os+CI_M_os_err          
    
		  
          ## create descriptives-matrix
          # independent samples
          desc_sample1 <- c(n1,M1,SD1,SE_M1,CI_M1_low,CI_M1_upp)
          desc_sample2 <- c(n2,M2,SD2,SE_M2,CI_M2_low,CI_M2_upp)
          descs <- rbind(desc_sample1,desc_sample2)
          # one-sample
          desc_os_sample <- c(n_os,M_os,SD_os,SE_M_os,CI_M_os_low,CI_M_os_upp)

          ## print descriptives as table            # table_descriptives$setVisible(visible=self$options$desc_show)
          # independent samples
          table_descriptives$setRow(rowNo=1, values=list(
            group=G1_name,
            n=descs[1,1],
            M=descs[1,2],
            SD=descs[1,3],
            SE=descs[1,4],
            CI_M_low=descs[1,5],
            CI_M_upp=descs[1,6]
          ))
          table_descriptives$setRow(rowNo=2, values=list(
            group=G2_name,
            n=descs[2,1],
            M=descs[2,2],
            SD=descs[2,3],
            SE=descs[2,4],
            CI_M_low=descs[2,5],
            CI_M_upp=descs[2,6]
          ))          
          
          # one-sample
          table_descriptives_os$setRow(rowNo=1, values=list(
            group='Sample',
            n=desc_os_sample[1],
            M=desc_os_sample[2],
            SD=desc_os_sample[3],
            SE=desc_os_sample[4],
            CI_M_low=desc_os_sample[5],
            CI_M_upp=desc_os_sample[6]
          ))
          table_descriptives_os$setRow(rowNo=2, values=list(
            group='Test value',
            n='',
            M=tv_os,
            SD='',
            SE='',
            CI_M_low='',
            CI_M_upp=''
          ))          
          

          #### calculate independent tests ####
          ### Welch's t-Test START ###
          # calculate Welch corrected standard error of mean difference (Eid et al., 2017, eq. F 11.11)
          SE_Welch <- sqrt((SD1^2/n1)+(SD2^2/n2))		    
		  
          # calculate Welch's t-value (Eid et al., 2017, eq. F 11.11)
          t_Welch <- M_diff/SE_Welch

          # calculate Welch-corrected degrees of freedom (Eid et al., 2017, eq. F 11.10)
          #rounding error: df_Welch <- (((SD1^2/n1)+(SD2^2/n2))^2)/((SD1^4/(n1^3-n1))+(SD2^4/(n2^3-n2)))
          #long version: df_Welch <- (((SD1^2/n1)+(SD2^2/n2))^2)/((SD1^4/((n1^2)*(n1-1)))+(SD2^4/((n2^2)*(n2-1))))
	        df_Welch <- (SE_Welch^4)/((SD1^4/((n1^2)*(n1-1)))+(SD2^4/((n2^2)*(n2-1))))
	  
          
          # p-table readout based on hypothesis
          if (hypo_tail_is == 'notequal') {
            # two-tailed test (M1 != M2), abs(t_Welch) otherwise p greater 1 possible
            p_Welch <- 2*pt(q=abs(t_Welch), df=df_Welch, lower.tail=FALSE)	# pt(): basic R-function
          } else if (hypo_tail_is == 'onegreater') {
            # one-tailed test (M1 > M2)
            p_Welch <- pt(q=t_Welch, df=df_Welch, lower.tail=FALSE)
          } else if (hypo_tail_is == 'twogreater') {
            # one-tailed test (M1 < M2)
            p_Welch <- pt(q=t_Welch, df=df_Welch, lower.tail=TRUE)
          } else {    # error-mode
            p_Welch <- NaN
            table_tests$setError('calculation p-Welch error: hypothesis selection independent samples')
          }
          		  
		      # calculate Cohen's d effect size for SD1!=SD2 & n1=n2 (Cohen, 1988, eq. 2.2.1, 2.2.2 & 2.3.2)
          d_Welch <- abs(M_diff)/sqrt((SD1^2+SD2^2)/2)
          # calculate Convidence Interval for Cohen's d (Revelle, 2025)
          CI_d_Welch <- psych::d.ci(d_Welch, n1=n1, n2=n2, alpha=CI_d)	# psych::d.ci(): psych R-package | psych::d.ci[1]=lower value, psych::d.ci[2]=d, psych::d.ci[3]=upper value
          CI_d_W_low <- CI_d_Welch[1]
          CI_d_W_upp <- CI_d_Welch[3]        
          
          ## calculate Convidence Interval for means-difference (Eid et al., 2017, eq. F 11.14a - F 11.14c)
          if (hypo_tail_is == 'notequal') {
            # t-critical readout for CI, (M1 != M2), (Eid et al., 2017, eq. F 11.14a)
            t_crit_CI_deltaM_Welch <- qt(CI_deltaM_Wd_2s,df_Welch)
            # calculate lower and upper CI-values, (M1 != M2), (Eid et al., 2017, eq. F 11.14a)
            CI_deltaM_err_Welch <- t_crit_CI_deltaM_Welch * SE_Welch
            CI_deltaM_Welch_low <- M_diff - CI_deltaM_err_Welch
            CI_deltaM_Welch_upp <- M_diff + CI_deltaM_err_Welch
          } else if (hypo_tail_is == 'onegreater') {
            # t-critical readout for CI, (M1 > M2) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_Welch <- qt(CI_deltaM_Wd_1s,df_Welch)
            # calculate lower and upper CI-values, (M1 > M2) (Eid et al., 2017, eq. F 11.14b)
            CI_deltaM_err_Welch <- t_crit_CI_deltaM_Welch * SE_Welch
            CI_deltaM_Welch_low <- M_diff - CI_deltaM_err_Welch
            CI_deltaM_Welch_upp <- +Inf
          } else if (hypo_tail_is == 'twogreater') {
            # t-critical readout for CI, (M1 < M2) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_Welch <- qt(CI_deltaM_Wd_1s,df_Welch)
            # calculate lower and upper CI-values, (M1 < M2) (Eid et al., 2017, eq. F 11.14c)
            CI_deltaM_err_Welch <- t_crit_CI_deltaM_Welch * SE_Welch
            CI_deltaM_Welch_low <- -Inf
            CI_deltaM_Welch_upp <- M_diff + CI_deltaM_err_Welch
          } else {      # error-mode
            CI_deltaM_Welch_low <- NaN
            CI_deltaM_Welch_upp <- NaN
            table_tests$setError('calculation CI(DeltaM)-Welch error: hypothesis selection independent samples')
          }         
          
		  
          # create output-vector
          results_Welch <- c(t_Welch,df_Welch,p_Welch,d_Welch,CI_d_W_low,CI_d_W_upp,M_diff,SE_Welch,CI_deltaM_Welch_low,CI_deltaM_Welch_upp)
          ### Welch's t-Test END ###
          
          
          ### Student's t-Test START ###
          # calculate pooled variance (Eid et al., 2017, eq. F 11.8)
          var_pooled_Stud <- (((SD1^2)*(n1-1))+((SD2^2)*(n2-1)))/((n1-1)+(n2-1))
          
          # calculate standard error of mean difference (Eid et al., 2017, eq. F 11.7)
          SE_Stud <- sqrt((var_pooled_Stud/n1)+(var_pooled_Stud/n2))
          
          # calculate Student's t-value (Eid et al., 2017, eq. F 11.9c)
          t_Stud <- M_diff/SE_Stud
          
          # calculate Student's degrees of freedom (Eid et al., 2017, p. 334)
          df_Stud <- (n1-1)+(n2-1)
          if (df_Stud == -2) {df_Stud <- NaN} #to suppress -2 in empty table
          
          # p-table readout
          if (hypo_tail_is == 'notequal') {
            # two-tailed test (M1 != M2), abs(t_Stud) otherwise p greater 1 possible
            p_Stud <- 2*pt(q=abs(t_Stud), df=df_Stud, lower.tail=FALSE)		# pt(): standard R-function
          } else if (hypo_tail_is == 'onegreater') {
            # one-tailed test (M1 > M2)
            p_Stud <- pt(q=t_Stud, df=df_Stud, lower.tail=FALSE)
          } else if (hypo_tail_is == 'twogreater')  {
            # one-tailed test (M1 < M2)
            p_Stud <- pt(q=t_Stud, df=df_Stud, lower.tail=TRUE)
          } else {    # error-mode
            p_Stud <- NaN
            table_tests$setError('calculation p-Student error: hypothesis selection independent samples')
          }
          
          # calculate Cohen's d effect size for Student's t-Test 
          #d_Stud <- t_Stud * sqrt((n1+n2)/(n1*n2)) = t_Stud * sqrt((1/n1)+(1/n2))           (Eid et al., 2017, eq. F 11.13b)
          d_Stud <- abs(M_diff)/sqrt(var_pooled_Stud) # abs() to prevent negative d values (see Cohen, 1988, eq. 2.2.2)
          # calculate Convidence Interval for Cohen's d (Revelle, 2025)
          CI_d_Stud <- psych::d.ci(d_Stud, n1=n1, n2=n2, alpha=CI_d)		# psych::d.ci(): psych R-package | psych::d.ci[1]=lower value, psych::d.ci[2]=d, psych::d.ci[3]=upper value          
          CI_d_S_low <- CI_d_Stud[1]
          CI_d_S_upp <- CI_d_Stud[3]  

          ## calculate Convidence Interval for means-difference (Eid et al., 2017, eq. F 11.14a - F 11.14c)
          if (hypo_tail_is == 'notequal') {
            # t-critical readout for CI, (M1 != M2), (Eid et al., 2017, eq. F 11.14a)
            t_crit_CI_deltaM_Stud <- qt(CI_deltaM_Wd_2s,df_Stud)
            # calculate lower and upper CI-values, (M1 != M2), (Eid et al., 2017, eq. F 11.14a)
            CI_deltaM_err_Stud <- t_crit_CI_deltaM_Stud * SE_Stud
            CI_deltaM_Stud_low <- M_diff - CI_deltaM_err_Stud
            CI_deltaM_Stud_upp <- M_diff + CI_deltaM_err_Stud
          } else if (hypo_tail_is == 'onegreater') {
            # t-critical readout for CI, (M1 > M2) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_Stud <- qt(CI_deltaM_Wd_1s,df_Stud)
            # calculate lower and upper CI-values, (M1 > M2) (Eid et al., 2017, eq. F 11.14b)
            CI_deltaM_err_Stud <- t_crit_CI_deltaM_Stud * SE_Stud
            CI_deltaM_Stud_low <- M_diff - CI_deltaM_err_Stud
            CI_deltaM_Stud_upp <- +Inf
          } else if (hypo_tail_is == 'twogreater') {
            # t-critical readout for CI, (M1 < M2) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_Stud <- qt(CI_deltaM_Wd_1s,df_Stud)
            # calculate lower and upper CI-values, (M1 < M2) (Eid et al., 2017, eq. F 11.14c)
            CI_deltaM_err_Stud <- t_crit_CI_deltaM_Stud * SE_Stud
            CI_deltaM_Stud_low <- -Inf
            CI_deltaM_Stud_upp <- M_diff + CI_deltaM_err_Stud
          } else {    # error-mode
            CI_deltaM_Stud_low <- NaN
            CI_deltaM_Stud_upp <- NaN
            table_tests$setError('calculation CI(DeltaM)-Student error: hypothesis selection independent samples')
          }  
 
          # create Student's t-Test output-vector
          results_Stud <- c(t_Stud,df_Stud,p_Stud,d_Stud,CI_d_S_low,CI_d_S_upp,M_diff,SE_Stud,CI_deltaM_Stud_low,CI_deltaM_Stud_upp)
          ### Student's t-Test END ###

          
          ### create output of results
          ## prepare text & table output
          # create output-matrix
          results <- rbind(results_Welch,results_Stud)
          
          # print results as text
          #self$results$text$setContent(results)
          #self$results$text$setContent(hypo_tail_is)
          
          # print t-tests results as table
          table_tests$setRow(rowNo=1, values=list(
            var='Welch&rsquo;s',
            t=results[1,1],
            df=results[1,2],
            p=results[1,3],
            d=results[1,4],
            CI_d_low=results[1,5],
            CI_d_upp=results[1,6],            
            deltaM=results[1,7],
            SE_deltaM=results[1,8],
            CI_deltaM_low=results[1,9],
            CI_deltaM_upp=results[1,10]
          ))
          table_tests$setRow(rowNo=2, values=list(
            var='Student&rsquo;s',
            t=results[2,1],
            df=results[2,2],
            p=results[2,3],
            d=results[2,4],
            CI_d_low=results[2,5],
            CI_d_upp=results[2,6],
            deltaM=results[2,7],
            SE_deltaM=results[2,8],
            CI_deltaM_low=results[2,9],
            CI_deltaM_upp=results[2,10]
          ))
          
          ## prepare plot-data
          # assemble plot-points into ggplot2 data-frame
          plotData <- data.frame(Sample = c(G1_name,G2_name),Mean = c(M1,M2), sel = c(CI_M1_low,CI_M2_low),seu = c(CI_M1_upp,CI_M2_upp))

          
          #### one-sample t-test START###
          # calculate degrees of freedom for one-sample t-test (Cohen, 1988, p. 46; Eid et al., 2017, p. 255)
          df_os <- n_os-1
          if (df_os == -1) {df_os <- NaN} #to suppress -1 in empty table
          
          # calculate empirical t-value (Eid et al., 2017, eq. F 8.25)
          t_os <- M_diff_os/SE_M_os
          
          # p-table readout
          if (hypo_tail_os == 'notequal_os') {     # two-tailed test (M_os != tv_os), abs(t_os) otherwise p greater 1 possible
            p_os <- 2*pt(q=abs(t_os), df=df_os, lower.tail=FALSE)		# pt(): standard R-function
          } else if (hypo_tail_os == 'onegreater_os') {            # one-tailed test (M_os > tv_os)
            p_os <- pt(q=t_os, df=df_os, lower.tail=FALSE)
          } else if (hypo_tail_os == 'twogreater_os') {            # one-tailed test (M_os < tv_os)
            p_os <- pt(q=t_os, df=df_os, lower.tail=TRUE)
          } else {    # error-mode
            p_os <- NaN
            table_tests_os$setError('calculation p-value error: hypothesis selection one-sample')
          }

          ## calculate effect size
          # calculate Cohen's d' (Cohen, 1988, eq. 2.3.3)
          d_os <- abs(M_diff_os/SD_os)  # abs() to prevent negative d values (see Cohen, 1988, eq. 2.2.2)
          # calculate corrected Cohen's d for direct interpretation (Cohen, 1988, eq. 2.3.4)
          d_os_corr <- d_os*sqrt(2)
                   
          ## calculate Convidence Interval for Cohen's d' and d (Revelle, 2025)
          # CI(d')
          CI_d_os <- psych::d.ci(d_os, n1=n_os, alpha=CI_d)	# psych::d.ci(): psych R-package | psych::d.ci[1]=lower value, psych::d.ci[2]=d, psych::d.ci[3]=upper value
          CI_d_os_low <- CI_d_os[1]
          CI_d_os_upp <- CI_d_os[3]
          # CI(d)
          CI_d_corr_os <- psych::d.ci(d_os_corr, n1=n_os, alpha=CI_d)	# psych::d.ci(): psych R-package | psych::d.ci[1]=lower value, psych::d.ci[2]=d, psych::d.ci[3]=upper value
          CI_d_corr_os_low <- CI_d_corr_os[1]
          CI_d_corr_os_upp <- CI_d_corr_os[3]          

          
          ## calculate standard error of mean difference
          # based on Eid et al. (2017, eq. F 8.25) SE(M) covers the same function in one-sample tests as SE(DeltaM) in independent t-tests

          ## calculate Convidence Interval for mean-difference (Eid et al., 2017, eq. F 11.14a - F 11.14c)
          if (hypo_tail_os == 'notequal_os') {
            # t-critical readout for CI, (M != c), (Eid et al., 2017, eq. F 11.14a)
            t_crit_CI_deltaM_os <- qt(CI_deltaM_Wd_2s,df_os)
            # calculate lower and upper CI-values, (Eid et al., 2017, eq. F 11.14a)
            CI_deltaM_err_os <- t_crit_CI_deltaM_os * SE_M_os   # using SE(M) of sample instead SE(dDeltaM)
            CI_deltaM_os_low <- M_diff_os - CI_deltaM_err_os
            CI_deltaM_os_upp <- M_diff_os + CI_deltaM_err_os
          } else if (hypo_tail_os == 'onegreater_os') {
            # t-critical readout for CI, (M > c) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_os <- qt(CI_deltaM_Wd_1s,df_os)
            # calculate lower and upper CI-values, (Eid et al., 2017, eq. F 11.14b)
            CI_deltaM_err_os <- t_crit_CI_deltaM_os * SE_M_os
            CI_deltaM_os_low <- M_diff_os - CI_deltaM_err_os
            CI_deltaM_os_upp <- +Inf
          } else if (hypo_tail_os == 'twogreater_os') {
            # t-critical readout for CI, (M < c) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_os <- qt(CI_deltaM_Wd_1s,df_os)
            # calculate lower and upper CI-values, (Eid et al., 2017, eq. F 11.14c)
            CI_deltaM_err_os <- t_crit_CI_deltaM_os * SE_M_os
            CI_deltaM_os_low <- -Inf
            CI_deltaM_os_upp <- M_diff_os + CI_deltaM_err_os
          } else {    # error-mode
            CI_deltaM_os_low <- NaN
            CI_deltaM_os_upp <- NaN
            table_tests_os$setError('calculation CI(DeltaM) error: hypothesis selection one-sample')
          }

          
          # create output-vector
          results_os <- c(t_os,df_os,p_os,d_os,CI_d_os_low,CI_d_os_upp,d_os_corr,CI_d_corr_os_low,CI_d_corr_os_upp,M_diff_os,CI_deltaM_os_low,CI_deltaM_os_upp)

          table_tests_os$setRow(rowNo=1, values=list(
            var='t-test',
            t=results_os[1],
            df=results_os[2],
            p=results_os[3],
            d=results_os[4],
            CI_d_low=results_os[5],
            CI_d_upp=results_os[6],
            d_corr=results_os[7],            
            CI_d_corr_low=results_os[8],
            CI_d_corr_upp=results_os[9],            
            deltaM=results_os[10],
            CI_deltaM_low=results_os[11],
            CI_deltaM_upp=results_os[12]
          ))
          
          ## prepare plot-data
          # assemble plot-points into ggplot2 data-frame
          plotData_os <- data.frame(Sample = '',Mean = M_os, sel = CI_M_os_low,seu = CI_M_os_upp)

          ### one-sample t-test END ###
          
          
          #### assign data to plot
          if (testselect == 'ttest_is') {     # independent samples selected
            desc_plot$setState(plotData)          
          } else {                            # one-sample selected
            desc_plot$setState(plotData_os) 
          }

        },


        .plot=function(desc_plot, ggtheme, theme, ...) {
          # local variables
          plotData <- desc_plot$state
          
          testValue <- self$options$testvalue_os
          testselect <- self$options$testselect
          
          # plot setting based on testselect
          if (testselect == 'ttest_is') {     # independent samples selected
            plot <- ggplot(data=plotData, aes(x=Sample, y=Mean)) +
              geom_errorbar(aes(ymin=sel, ymax=seu, width=.1), size=.8, colour=theme$color[2]) +
              geom_point(aes(x=Sample, y=Mean), color=theme$color[1], fill=theme$fill[1], size=3) + 
              ggtheme #theme_bw()
          } else {                            # one-sample selected
            plot <- ggplot(data=plotData, aes(x=Sample, y=Mean)) +
              geom_hline(yintercept = testValue, linetype="dashed") +
              geom_errorbar(aes(ymin=sel, ymax=seu, width=.05), size=.8, colour=theme$color[2]) +
              geom_point(aes(x=Sample, y=Mean), color=theme$color[1], fill=theme$fill[1], size=3) + 
              ggtheme #theme_bw()
          }
            
          print(plot)
          TRUE
        }
      
  )
)

### References ###
# Cohen, J. (1988). Statistical power analysis for the behavioral sciences (2nd ed). L. Erlbaum Associates.
# Eid, M., Gollwitzer, M., & Schmitt, M. (2017). Statistik und Forschungsmethoden (5., korrigierte Auflage). Beltz.
# R Core Team. (2025). R: A Language and Environment for Statistical Computing (Version 4.5.0) [Computer Software]. R Foundation for Statistical Computing. https://www.R-project.org/
# Revelle, W. (2025). psych: Procedures for Psychological, Psychometric, and Personality Research (Version 2.5.3) [R package]. https://cran.r-project.org/web/packages/psych/index.html
# Wickham, H., Chang, W., Henry, L., Pedersen, T. L., Takahashi, K., Wilke, C., Woo, K., Yutani, H., Dunnington, D., & van den Brand, T. (2025). ggplot2: Create Elegant Data Visualisations Using the Grammar of Graphics (Version 3.5.2) [R package]. Posit, PBC. https://cran.r-project.org/package=ggplot2