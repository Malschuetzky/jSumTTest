jSumTTestClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "jSumTTestClass",
    inherit = jSumTTestBase,
    private = list(
        .run = function() {
          
          # VERSION 1.1.0 - 2025-05-31
          
          
          
          # `self$data` contains the data
          # `self$options` contains the options
          # `self$results` contains the results object (to populate)



          ### Data read in ###
		      # Group 1 data
          n1 <- self$options$n1
          M1 <- self$options$M1
          SD1 <- self$options$SD1
          
		      # Group 2 data
          n2 <- self$options$n2
          M2 <- self$options$M2
          SD2 <- self$options$SD2
		  
		      # Group 1 and 2 names
          G1_name <- self$options$name1
          G2_name <- self$options$name2		  


		      ### Options read in and calculations ###
		      # Hypthesis tail and direction 
          hypo_tail <- self$options$hypo
                   
		      # Confidence Interval width for means-difference in test-values-table
          CI_deltaM_W_GUI <- self$options$CI_deltaM_width
          CI_deltaM_Wd_1s <- CI_deltaM_W_GUI/100 # calculate decimal value, also one-tailed decimal value
          CI_deltaM_W_2s <- CI_deltaM_W_GUI+((100-CI_deltaM_W_GUI)/2) # calculate two-tailed value
          CI_deltaM_Wd_2s <- CI_deltaM_W_2s/100 # calculte decimal value two-tailed
          
		      # Confidence Interval width for means in descriptives-values-table
          CI_M_W_GUI <- self$options$CI_M_width
          CI_M_W <- CI_M_W_GUI+((100-CI_M_W_GUI)/2) # as CI(M) is always two-tailed
          
		      # Confidence Interval width for Cohen's d effect-size
          CI_d_GUI <- self$options$CI_d_width
          CI_d <- 1-(CI_d_GUI/100)
          
          
#desc_tab_show <- self$options$desc_show
          
          
          
          ### local variables ini ###
          table_tests <- self$results$ttesttable # test-values
          table_descriptives <- self$results$desctable	# descriptives values
          
          hypo_text <- 'INI2' #footnote for table_tests
          

          
          ### Descriptives ###
          ## calculate mean difference
          M_diff <- M1-M2
          
		  
          ## calculate standard errors of means (Eid et al., 2017, F 8.4b)
          SE_M1 <- SD1/sqrt(n1)
          SE_M2 <- SD2/sqrt(n2)
          
          
          ## calculate Convidence Interval for means
          # calculate z-value of given CI width
          z_CI_value <- qnorm(CI_M_W/100)	# qnorm(): standard R-function
          # calculate CI boarders (Eid et al., 2017, F 8.16)
          CI_M1_err <- z_CI_value*SE_M1
          CI_M1_low <- M1-CI_M1_err
          CI_M1_upp <- M1+CI_M1_err
		  
          CI_M2_err <- z_CI_value*SE_M2
          CI_M2_low <- M2-CI_M2_err
          CI_M2_upp <- M2+CI_M2_err
    
		  
          ## create descriptives-matrix
          desc_group1 <- c(n1,M1,SD1,SE_M1,CI_M1_low,CI_M1_upp)
          desc_group2 <- c(n2,M2,SD2,SE_M2,CI_M2_low,CI_M2_upp)
          descs <- rbind(desc_group1,desc_group2)
          
          ## print descriptives as table
          # prepare CI SuperTitle
          CI_M_h <- jmvcore::format('{} % CI(<i>M</i>)', CI_M_W_GUI)
          table_descriptives$getColumn('CI_M_low')$setSuperTitle(CI_M_h)
          table_descriptives$getColumn('CI_M_upp')$setSuperTitle(CI_M_h)          
# print table 
# table_descriptives$setVisible(visible=desc_tab_show)
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
          

          
          ### Welch's t-Test START ###
          # calculate standard error of mean difference
          SE_Welch <- sqrt((SD1^2/n1)+(SD2^2/n2))		    
		  
          # calculate Welch's t-value (Eid et al., 2017, eq. F 11.11)
          t_Welch <- M_diff/SE_Welch

          # calculate Welch-corrected degrees of freedom (Eid et al., 2017, eq. F 11.10)
          #rounding error: df_Welch <- (((SD1^2/n1)+(SD2^2/n2))^2)/((SD1^4/(n1^3-n1))+(SD2^4/(n2^3-n2)))
          #long version: df_Welch <- (((SD1^2/n1)+(SD2^2/n2))^2)/((SD1^4/((n1^2)*(n1-1)))+(SD2^4/((n2^2)*(n2-1))))
	        df_Welch <- (SE_Welch^4)/((SD1^4/((n1^2)*(n1-1)))+(SD2^4/((n2^2)*(n2-1))))
	  
          
          # p-table readout and footnote setting based on hypothesis
          if (hypo_tail == 'notequal') {
            # two-tailed test (M1 != M2), abs(t_Welch) otherwise p greater 1 possible
            p_Welch <- 2*pt(q=abs(t_Welch), df=df_Welch, lower.tail=FALSE)	# pt(): basic R-function
            hypo_text <- '<i>H<sub>A</sub></i>: μ<sub>1</sub> &#8800 μ<sub>2</sub>'
          } else if (hypo_tail == 'onegreater') {
            # one-tailed test (M1 > M2)
            p_Welch <- pt(q=t_Welch, df=df_Welch, lower.tail=FALSE)
            hypo_text <- '<i>H<sub>A</sub></i>: μ<sub>1</sub> > μ<sub>2</sub>'
          } else {
            # one-tailed test (M1 < M2)
            p_Welch <- pt(q=t_Welch, df=df_Welch, lower.tail=TRUE)
            hypo_text <- '<i>H<sub>A</sub></i>: μ<sub>1</sub> < μ<sub>2</sub>'
          }
          		  
		  # calculate Cohen's d effect size for SD1!=SD2 & n1=n2 (Cohen, 1988, eq. 2.2.1, 2.2.2 & 2.3.2)
          d_Welch <- abs(M_diff)/sqrt((SD1^2+SD2^2)/2)
          # calculate Convidence Interval for Cohen's d (Revelle, 2024)
          CI_d_Welch <- psych::d.ci(d_Welch, n1=n1, n2=n2, alpha=CI_d)	# psych::d.ci(): psych R-package | psych::d.ci[1]=lower value, psych::d.ci[2]=d, psych::d.ci[3]=upper value
          CI_d_W_low <- CI_d_Welch[1]
          CI_d_W_upp <- CI_d_Welch[3]          
          
          ## calculate Convidence Interval for means-difference (Eid et al., 2017, eq. F 11.14a - F 11.14c)
          if (hypo_tail == 'notequal') {
            # t-critical readout for CI, (M1 != M2), (Eid et al., 2017, eq. F 11.14a)
            t_crit_CI_deltaM_Welch <- qt(CI_deltaM_Wd_2s,df_Welch)
            # calculate lower and upper CI-values, (M1 != M2), (Eid et al., 2017, eq. F 11.14a)
            CI_deltaM_err_Welch <- t_crit_CI_deltaM_Welch * SE_Welch
            CI_deltaM_Welch_low <- M_diff - CI_deltaM_err_Welch
            CI_deltaM_Welch_upp <- M_diff + CI_deltaM_err_Welch
          } else if (hypo_tail == 'onegreater') {
            # t-critical readout for CI, (M1 > M2) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_Welch <- qt(CI_deltaM_Wd_1s,df_Welch)
            # calculate lower and upper CI-values, (M1 > M2) (Eid et al., 2017, eq. F 11.14b)
            CI_deltaM_err_Welch <- t_crit_CI_deltaM_Welch * SE_Welch
            CI_deltaM_Welch_low <- M_diff - CI_deltaM_err_Welch
            CI_deltaM_Welch_upp <- +Inf
          } else {
            # t-critical readout for CI, (M1 < M2) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_Welch <- qt(CI_deltaM_Wd_1s,df_Welch)
            # calculate lower and upper CI-values, (M1 < M2) (Eid et al., 2017, eq. F 11.14c)
            CI_deltaM_err_Welch <- t_crit_CI_deltaM_Welch * SE_Welch
            CI_deltaM_Welch_low <- -Inf
            CI_deltaM_Welch_upp <- M_diff + CI_deltaM_err_Welch
          }          
          
		  
          # create output-vector
          results_Welch <- c(t_Welch,df_Welch,p_Welch,d_Welch,CI_d_W_low,CI_d_W_upp,M_diff,SE_Welch,CI_deltaM_Welch_low,CI_deltaM_Welch_upp)
          ### Welch's t-Test END ###
          
          
          
          ### Student's t-Test START ###
          # calculate pooled variance (Eid et al., 2017, eq. F 11.8)
          var_pooled_Stud <- (((SD1^2)*(n1-1))+((SD2^2)*(n2-1)))/((n1-1)+(n2-1))
          
          # calculate standard error (Eid et al., 2017, eq. F 11.7)
          SE_Stud <- sqrt((var_pooled_Stud/n1)+(var_pooled_Stud/n2))
          
          # calculate Student's t-value (Eid et al., 2017, eq. F 11.9c)
          t_Stud <- M_diff/SE_Stud
          
          # calculate Student's degrees of freedom (Eid et al., 2017, p. 334)
          df_Stud <- (n1-1)+(n2-1)
          if (df_Stud == -2) {df_Stud <- NaN} #to suppress -2 in empty table
          
          # p-table readout
          if (hypo_tail == 'notequal') {
            # two-tailed test (M1 != M2), abs(t_Stud) otherwise p greater 1 possible
            p_Stud <- 2*pt(q=abs(t_Stud), df=df_Stud, lower.tail=FALSE)		# pt(): standard R-function
          } else if (hypo_tail == 'onegreater') {
            # one-tailed test (M1 > M2)
            p_Stud <- pt(q=t_Stud, df=df_Stud, lower.tail=FALSE)
          } else {
            # one-tailed test (M1 < M2)
            p_Stud <- pt(q=t_Stud, df=df_Stud, lower.tail=TRUE)
          }
          
          # calculate Cohen's d effect size for Student's t-Test (Eid et al., 2017, eq. F 11.13b)
          #d_Stud <- t_Stud * sqrt((n1+n2)/(n1*n2))
          d_Stud <- abs(M_diff)/sqrt(var_pooled_Stud) # abs() to prevent negative d values (compared to Cohen, 1988, eq. 2.2.2)
          # calculate Convidence Interval for Cohen's d (Revelle, 2024)
          CI_d_Stud <- psych::d.ci(d_Stud, n1=n1, n2=n2, alpha=CI_d)		# psych::d.ci(): psych R-package | psych::d.ci[1]=lower value, psych::d.ci[2]=d, psych::d.ci[3]=upper value          
          CI_d_S_low <- CI_d_Stud[1]
          CI_d_S_upp <- CI_d_Stud[3]  

          ## calculate Convidence Interval for means-difference (Eid et al., 2017, eq. F 11.14a - F 11.14c)
          if (hypo_tail == 'notequal') {
            # t-critical readout for CI, (M1 != M2), (Eid et al., 2017, eq. F 11.14a)
            t_crit_CI_deltaM_Stud <- qt(CI_deltaM_Wd_2s,df_Stud)
            # calculate lower and upper CI-values, (M1 != M2), (Eid et al., 2017, eq. F 11.14a)
            CI_deltaM_err_Stud <- t_crit_CI_deltaM_Stud * SE_Stud
            CI_deltaM_Stud_low <- M_diff - CI_deltaM_err_Stud
            CI_deltaM_Stud_upp <- M_diff + CI_deltaM_err_Stud
          } else if (hypo_tail == 'onegreater') {
            # t-critical readout for CI, (M1 > M2) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_Stud <- qt(CI_deltaM_Wd_1s,df_Stud)
            # calculate lower and upper CI-values, (M1 > M2) (Eid et al., 2017, eq. F 11.14b)
            CI_deltaM_err_Stud <- t_crit_CI_deltaM_Stud * SE_Stud
            CI_deltaM_Stud_low <- M_diff - CI_deltaM_err_Stud
            CI_deltaM_Stud_upp <- +Inf
          } else {
            # t-critical readout for CI, (M1 < M2) (Eid et al., 2017, eq. F 11.14b & F 11.14c)
            t_crit_CI_deltaM_Stud <- qt(CI_deltaM_Wd_1s,df_Stud)
            # calculate lower and upper CI-values, (M1 < M2) (Eid et al., 2017, eq. F 11.14c)
            CI_deltaM_err_Stud <- t_crit_CI_deltaM_Stud * SE_Stud
            CI_deltaM_Stud_low <- -Inf
            CI_deltaM_Stud_upp <- M_diff + CI_deltaM_err_Stud
          }          
 

          
          # create Student's t-Test output-vector
          results_Stud <- c(t_Stud,df_Stud,p_Stud,d_Stud,CI_d_S_low,CI_d_S_upp,M_diff,SE_Stud,CI_deltaM_Stud_low,CI_deltaM_Stud_upp)
          ### Student's t-Test END ###
          
		  
          
          ### create output of results
          # create output-matrix
          results <- rbind(results_Welch,results_Stud)
          
          
          # print results as text
          #self$results$text$setContent(results)
          #self$results$text$setContent(hypo_tail)
     
          
          ## print t-tests results as table
          
          # prepare CI(d) SuperTitle
          CI_d_h <- jmvcore::format('{} % CI(<i>d</i>)', CI_d_GUI)
          table_tests$getColumn('CI_d_low')$setSuperTitle(CI_d_h)
          table_tests$getColumn('CI_d_upp')$setSuperTitle(CI_d_h)
          
          # prepare CI(mean difference) SuperTitle
          CI_deltaM_h <- jmvcore::format('{} % CI(&Delta;<i>M</i>)', CI_deltaM_W_GUI)
          table_tests$getColumn('CI_deltaM_low')$setSuperTitle(CI_deltaM_h)
          table_tests$getColumn('CI_deltaM_upp')$setSuperTitle(CI_deltaM_h)

          # print table
          table_tests$setNote('1',hypo_text, init=TRUE)
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
          plotData <- data.frame(Group = c(G1_name,G2_name),Mean = c(M1,M2), sel = c(CI_M1_low,CI_M2_low),seu = c(CI_M1_upp,CI_M2_upp))
          # assign data to image
          image <- self$results$plot
          image$setState(plotData)
          
          # set plot title
          plot_h <- jmvcore::format('Descriptives Plot (mean and {} % CI)', CI_M_W_GUI)
          image$setTitle(plot_h)
          
        },

        .plot=function(image, ...) {
          plotData <- image$state

          plot <- ggplot(plotData, aes(x=Group, y=Mean)) +
            geom_errorbar(aes(ymin=sel, ymax=seu, width=.1)) +
            geom_point(aes(x=Group, y=Mean)) + theme_classic()
                  
          print(plot)
          TRUE
        }
  )
)

### References ###
# Cohen, J. (1988). Statistical power analysis for the behavioral sciences (2nd ed). L. Erlbaum Associates.
# Eid, M., Gollwitzer, M., & Schmitt, M. (2017). Statistik und Forschungsmethoden (5., korrigierte Auflage). Beltz.
# R Core Team. (2024). R: A Language and Environment for Statistical Computing (Version 4.4.1) [Computer Software]. R Foundation for Statistical Computing. https://www.R-project.org/
# Revelle, W. (2024). psych: Procedures for Psychological, Psychometric, and Personality Research (Version 2.4.6.26) [R package]. https://cran.r-project.org/web/packages/psych/index.html
# Wickham, H., Chang, W., Henry, L., Pedersen, T. L., Takahashi, K., Wilke, C., Woo, K., Yutani, H., Dunnington, D., & van den Brand, T. (2024). ggplot2: Create Elegant Data Visualisations Using the Grammar of Graphics (Version 3.5.1) [R package]. Posit, PBC. https://cran.r-project.org/package=ggplot2