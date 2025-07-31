use "C:\Users\carao\OneDrive - London School of Economics\0 PB410 Dissertation\0 Final Data Workings\dataset PLUR IGNO with variables.dta", clear


************************************************************************************

* Create numeric versions for Q1, 2, 4
foreach i in 1 2 4 {
    *gen q`i'_num = .
    replace q`i'_num = 1 if trim(q`i') == "Disagree strongly"
    replace q`i'_num = 2 if trim(q`i') == "Disagree slightly"
    replace q`i'_num = 3 if trim(q`i') == "Neither agree nor disagree"
    replace q`i'_num = 4 if trim(q`i') == "Agree slightly"
    replace q`i'_num = 5 if trim(q`i') == "Agree strongly"
}

* Create numeric versions for Q3, 5, (reverse coded!)

foreach i in 3 5 {
    *gen q`i'_num = .
    replace q`i'_num = 5 if trim(q`i') == "Disagree strongly"
    replace q`i'_num = 4 if trim(q`i') == "Disagree slightly"
    replace q`i'_num = 3 if trim(q`i') == "Neither agree nor disagree"
    replace q`i'_num = 2 if trim(q`i') == "Agree slightly"
    replace q`i'_num = 1 if trim(q`i') == "Agree strongly"
}

************************************************************************************
*pluralistic ignorance: this is what you answered YOURSELF
************************************************************************************

*creating dummy variables
foreach i in 1 2 3 4 5 {
    *gen dummy_q`i'_num = .
    replace dummy_q`i'_num = 0 if dummy_q`i' == "yourself"
    replace dummy_q`i'_num = 1 if dummy_q`i' == "otherpeople"
}


*NO CONTROLS 

foreach i in 1 2 3 4 5 {
    regress q`i'_num dummy_q`i'_num
}

*DEMOGRAPHIC CONTROLS

foreach i in 1 2 3 4 5 {
    regress q`i'_num dummy_q`i'_num genderbin white_binary hh_abrbin income_group agebinary employmentbin residency_uk educationbin
}

************************************************************************************
*pluralistic ignorance: this is what you think the ENGLISH PUBLIC answered
************************************************************************************

*creating dummy variables
foreach i in 1 2 3 4 5 {
    *gen dummy_q`i'_num = .
    replace dummy_q`i'_num = 1 if dummy_q`i' == "yourself"
    replace dummy_q`i'_num = 0 if dummy_q`i' == "otherpeople"
}

*NO CONTROLS 

foreach i in 1 2 3 4 5 {
    regress q`i'_num dummy_q`i'_num
}

*DEMOGRAPHIC CONTROLS

foreach i in 1 2 3 4 5 {
    regress q`i'_num dummy_q`i'_num genderbin white_binary hh_abrbin income_group agebinary employmentbin residency_uk educationbin
}
