************************************************************************************
*After running the Do file which generates all the variables, running this do file will get the results


*Internal consistency and factor analysis testing
************************************************************************************
*SSOSH
* internal consistency
alpha SSOSH1num SSOSH2num SSOSH3num
*factor analysis
factor SSOSH1num SSOSH2num SSOSH3num, factors(1)

reg SSOSH1num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg SSOSH2num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg SSOSH3num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk

************************************
*PSOSH
*internal consistency
alpha PSOSH1num PSOSH2num PSOSH3num PSOSH4num PSOSH5num
*factor analysis
factor PSOSH1num PSOSH2num PSOSH3num PSOSH4num PSOSH5num, factors(1)

reg PSOSH1num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg PSOSH2num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg PSOSH3num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg PSOSH4num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg PSOSH5num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk

************************************
*Self-esteem BRES-5
*internal consistency
alpha esteem1num esteem2num esteem3num esteem4num esteem5num
*factor analysis
factor esteem1num esteem2num esteem3num esteem4num esteem5num, factors(1)

reg esteem1num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg esteem2num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg esteem3num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg esteem4num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg esteem5num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk

************************************
*Estimate of others' stigma sum (CAMI 5 questions)
*internal consistency
alpha estimated_others_answer1_num estimated_others_answer2_num estimated_others_answer3_num estimated_others_answer4_num estimated_others_answer5_num
*factor analysis
factor estimated_others_answer1_num estimated_others_answer2_num estimated_others_answer3_num estimated_others_answer4_num estimated_others_answer5_num

reg estimated_others_answer1_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg estimated_others_answer2_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg estimated_others_answer3_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg estimated_others_answer4_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg estimated_others_answer5_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk

************************************
*Own stigma sum (CAMI 5 questions)
*internal consistency
alpha ownstigma1_num ownstigma2_num ownstigma3_num ownstigma4_num ownstigma5_num
*factor analysis
factor ownstigma1_num ownstigma2_num ownstigma3_num ownstigma4_num ownstigma5_num

reg ownanwer1_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg ownanwer2_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg ownanwer3_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg ownanwer4_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg ownanwer5_num genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk


************************************************************************************
*TREATMENT OUTCOMES
************************************************************************************
//testing normal distribution

histogram gplikely_num, normal
qnorm gplikely_num
swilk gplikely_num

histogram friendcomfort_num, normal
qnorm friendcomfort_num
swilk friendcomfort_num

histogram employercomfort_num, normal
qnorm employercomfort_num
swilk employercomfort_num


//T TESTS
ttest gplikely_num, by(treatmentgroup) unequal
ttest gplikely_binary, by(treatmentgroup) unequal

ttest friendcomfort_num, by(treatmentgroup) unequal
ttest employercomfort_num, by(treatmentgroup) unequal 


//Regressions

reg gplikely_num treatmentgroup genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg gplikely_binary treatmentgroup genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk

reg friendcomfort_num treatmentgroup genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk
reg employercomfort_num treatmentgroup genderbin white_binary age_incremental HEdegree income_group socialgradebin familiarity_level residency_uk


//Differences in the treatment outcome by wedge category: GP

regress gplikely_num i.treat_X_wedge_five, robust

regress gplikely_num i.treat_X_wedge_five genderbin white_binary age_incremental i.HEdegree i.income_group socialgradebin familiarity_level residency_uk, robust


************************************************************************************
*SEM ANALYSIS
************************************************************************************

sem (ownstigma_sum <- estimated_others_stigma_sum PSOSH_sum treatmentgroup soughthelpbin) ///
    (SSOSH_sum <- estimated_others_stigma_sum PSOSH_sum ownstigma_sum treatmentgroup soughthelpbin) ///
    (esteemsum <- ownstigma_sum SSOSH_sum treatmentgroup soughthelpbin) ///
    (gplikely_binary <- SSOSH_sum esteemsu treatmentgroup soughthelpbin), ///
    nocapslatent standardized
      
      
nlcom _b[esteemsum:SSOSH_sum] * _b[gplikely_binary:esteemsum]


*Wedge distribution and categories graph
graph twoway ///
    (histogram wedge, discrete freq color(ltblue)) ///
    (pci 0 -8.5 25 -8.5, lcolor(red) lwidth(medium)) ///
    (pci 0 -3.5 25 -3.5, lcolor(red) lwidth(medium)) ///
    (pci 0 -0.5 25 -0.5, lcolor(red) lwidth(medium)) ///
    (pci 0 0.5 25 0.5, lcolor(red) lwidth(medium)), ///
    title("Wedge Distribution with Category Boundaries") ///
    subtitle("Red lines show category cutpoints - Zero wedge is isolated as separate category") ///
    legend(off) ///
    xlabel(-16(2)6) ///
    ylabel(0(5)25) ///
    xtitle("Wedge Score (Own Stigma Score - Estimated Public Stigma)") ///
    ytitle("Frequency") ///
    note("Wedge = Perceived public stigma - Own stigma perception" ///
         "Biggest wedge (-16 to -9): n=59 (28.4%) | Medium wedge (-8 to -4): n=62 (29.8%)" ///
         "Small wedge (-3 to -1): n=52 (25.0%) | Zero wedge (0): n=17 (8.2%) | Positive wedge (1+): n=18 (8.7%)" ///
         "Total N=208. Negative values = overestimating public stigma.", size(medsmall))




		 
