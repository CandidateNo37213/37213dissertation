use "H:\FINALdata273entries.dta", clear

*CONTROL GROUP = 0, TREATMENT GROUP = 1
label define treatmentgroup_lbl 1 "1: treatment group" 0 "0: control group"

label values treatmentgroup treatmentgroup_lbl 

*fixing typo in cleaned data
rename emoloyment employment

************************************************************************************
*DEMOGRAPHIC BINARIES
************************************************************************************
*0 is the more common one

*binary for gender, FEMALE AS REFERENCE

gen genderbin = .
replace genderbin = 1 if gender == "Male"
replace genderbin = 0 if gender == "Female"

label define gender_lbl 0 "0: Female" 1 "1: Male"

label values genderbin gender_lbl

************************************************************************************
*binary for ethnicity, WHITE AS REFERENCE

gen white_binary = .
replace white_binary = 0 if ethnicity == "British/English Welsh/Scottish/Northern Irish"
replace white_binary = 0 if ethnicity == "Other White background"
replace white_binary = 0 if ethnicity == "White Irish"
replace white_binary = 1 if ethnicity != "British/English Welsh/Scottish/Northern Irish" & ethnicity != "Other White background" & ethnicity != "White Irish" & ethnicity != "Prefer not to say"

label define white_lbl 0 "0: White" 1 "1: Non-White"

label values white_binary white_lbl

************************************************************************************
*incremental code for age, 18-24 IS REFERENCE

gen age_incremental = .
replace age_incremental = 0 if age == "18-24"
replace age_incremental = 1 if age == "25-34"
replace age_incremental = 2 if age == "35-44"
replace age_incremental = 3 if age == "45-54"
replace age_incremental = 4 if age == "55-64"
replace age_incremental = 5 if age == "65-74"
replace age_incremental = 6 if age == "75-84"
replace age_incremental = 7 if age == "85 and above"

label define age_inc_lbl 0 "0: 18-24" 1 "1: 25-34" 2 "2: 35-44" 3 "3: 45-54" 4 "4: 55-64" 5 "5: 65-74" 6 "6: 75-84" 7 "7: 85 and above"

label values age_incremental age_inc_lbl

************************************************************************************
*binary for HE degree/ not, NO HE DEGREE IS REFERENCE

gen HEdegree = .
replace HEdegree = 0 if education == "A-levels or equivalent" | education == "Vocational qualification"
replace HEdegree = 1 if education == "Undergraduate degree"
replace HEdegree = 2 if education == "Postgraduate degree"

label define HE_lbl 0 "0: No HE Degree" 1 "1: Has HE Degree" 2 "2: Has Postgraduate Degree"

label values HEdegree HE_lbl

************************************************************************************
*INCOME GROUPS, 0-10K IS REFERENCE

gen income_group = .
replace income_group = 0 if income == "£0 – £9,999"
replace income_group = 1 if income == "£10,000 – £14,999" | income == "£15,000 – £19,999"
replace income_group = 2 if income == "£20,000 – £24,999" | income == "£25,000 – £29,999"
replace income_group = 3 if income == "£30,000 – £39,999"
replace income_group = 4 if income == "£40,000 – £49,999"
replace income_group = 5 if income == "£50,000 – £59,999"
replace income_group = 6 if income == "£60,000 – £74,999" | income == "£75,000 – £99,999" | income == "£100,000 – £149,999" | income == "£150,000 and over"

label define income_grp_lbl 0 "1: 0–10k" 1 "2: 10–20k" 2 "3: 20–30k" 3 "4: 30–40k" 4 "5: 40–50k" 5 "6: 50-60k" 6 "60k+"

label values income_group income_grp_lbl

************************************************************************************
*household earner - deprivation proxy

gen householdearner_clean = stritrim(ustrregexra(subinstr(subinstr(householdearner, char(10), "", .), char(13), "", .), "[\u2018\u2019\u201C\u201D]", "'"))

gen hh_abr = cond(householdearner_clean == "A professional occupationFor example, a teacher, nurse, physiotherapist, social worker, musician, police officer (sergeant or above), software designer, accountant, solicitor, medical practitioner, scientist, civil or mechanical engineer", "prof", cond(householdearner_clean == "A manager or administrator For example, a finance manager, chief executive, large business owner, office manager, retail manager, bank manager, restaurant manager or warehouse manager", "mgr", cond(householdearner_clean == "A clerical or intermediate occupationFor example, a secretary, personal assistant, call centre agent, clerical worker, or nursery nurse", "cler", cond(householdearner_clean == "A technical or craft occupationFor example, a motor mechanic, plumber, printer, electrician, gardener or train driver", "tech", cond(householdearner_clean == "A routine, semi-routine manual or service occupationFor example, a postal worker, machine operative, security guard, caretaker, farm worker, catering assistant, sales assistant, HGV driver, cleaner, porter, packer, labourer, waiter/waitress, or bar staff", "routine", cond(householdearner_clean == "Long-term unemployedFor example, they claimed Jobseeker's Allowance or an earlier unemployment benefit for more than a year", "unemp", cond(householdearner_clean == "A small business owner who employed less than 25 peopleFor example, they owned a corner shop, small plumbing company, retail shop, single restaurant or cafe, taxi, or garage", "smb", "")))))))

gen socialgrade = .
replace socialgrade = 1 if inlist(hh_abr, "mgr", "prof")
replace socialgrade = 2 if hh_abr == "cler"
replace socialgrade = 3 if hh_abr == "tech"
replace socialgrade = 4 if inlist(hh_abr, "routine", "unemp")
replace socialgrade = 4 if hh_abr == "smb"

label define socialgrade_lbl 1 "AB: Professional/Managerial" 2 "C1: Other non-manual" 3 "C2: Skilled manual" 4 "DE: Semi-/unskilled manual & benefits dependent"

label values socialgrade socialgrade_lbl

*there are so few participants with non-professional or managerial, so i have binirised these into professional vs. non professional

gen socialgradebin = 0
replace socialgradebin = . if socialgrade == .
replace socialgradebin = 1 if socialgrade == 1

label define socialgradebin_lbl 0 "0: non-professional" 1 "1: manager/ prof" 
label values socialgradebin socialgradebin_lbl


************************************************************************************
*residency

gen residency_uk = 0
replace residency_uk = 1 if residency == "I do not live in the UK"
replace residency_uk = . if residency == "Prefer not to say"

label define residency_uk_lbl 0 "0: Lives in UK" 1 "1: Does NOT live in UK" 
label values residency_uk residency_uk_lbl


************************************************************************************
*FAMILIARITY LEVEL W MI

split closestperson, parse(",") generate(entry_closest_person)

foreach var of varlist entry_closest_person1-entry_closest_person7 {
    replace `var' = trim(`var')
}


*does the participant know anyone with a MI
gen knows_someone = 0

foreach var of varlist entry_closest_person1-entry_closest_person7 {
    replace knows_someone = 1 if inlist(`var', ///
        "Immediate family (spouse\child\sister\brother\parent etc)", ///
        "Partner (living with you)", ///
        "Partner (not living with you)", ///
        "Other family (uncle\aunt\cousin\grand parent etc)", ///
        "Friend", ///
        "Acquaintance", ///
        "Work colleague")
}

label define knows_someone_lbl 0 "0: Knows noone with MI" 1 "1: Knows someone with MI" 
label values knows_someone knows_someone_lbl


*does the participant have a MI themselves
gen has_self = 0

foreach var of varlist entry_closest_person1-entry_closest_person7 {
    replace has_self = 1 if `var' == "Self"
}

label define has_self_lbl 0 "0: Doesn't have MI" 1 "1: Has MI themselves" 
label values has_self has_self_lbl



*familiarity level

gen familiarity_level = .

* Case 0: Has MI themselves
replace familiarity_level = 0 if has_self == 1

* Case 1: Doesn't have MI, but knows someone else
replace familiarity_level = 1 if has_self == 0 & knows_someone == 1

* Case 2: Doesn't have MI and doesn't know anyone else
replace familiarity_level = 2 if has_self == 0 & knows_someone == 0

* Optional: label the new variable
label define familiarity_lbl ///
    0 "0: Has MI themselves" ///
    1 "1: Knows someone with MI (not themselves)" ///
    2 "2: Knows no one with MI"

label values familiarity_level familiarity_lbl

************************************************************************************
*sought help before?

gen soughthelpbin = .
replace soughthelpbin = 1 if soughthelp == "Yes"
replace soughthelpbin = 0 if soughthelp == "No"

label define soughthelp_lbl 1 "1: Has sought help" 0 "0: Has Not sought help"
label values soughthelpbin soughthelp_lbl


************************************************************************************
**# Bookmark #1
*SSOSH-3
************************************************************************************

gen SSOSH1num = .
*5 = highest stigma, 1 = lowest stigma
replace SSOSH1num = 5 if trim(selfstigma1) == "Agree strongly"
replace SSOSH1num = 4 if trim(selfstigma1) == "Agree slightly"
replace SSOSH1num = 3 if trim(selfstigma1) == "Neither agree nor disagree"
replace SSOSH1num = 2 if trim(selfstigma1) == "Disagree slightly"
replace SSOSH1num = 1 if trim(selfstigma1) == "Disagree strongly"

gen SSOSH2num = .
*5 = highest stigma, 1 = lowest stigma
replace SSOSH2num = 5 if trim(selfstigma2) == "Agree strongly"
replace SSOSH2num = 4 if trim(selfstigma2) == "Agree slightly"
replace SSOSH2num = 3 if trim(selfstigma2) == "Neither agree nor disagree"
replace SSOSH2num = 2 if trim(selfstigma2) == "Disagree slightly"
replace SSOSH2num = 1 if trim(selfstigma2) == "Disagree strongly"

gen SSOSH3num = .
*5 = highest stigma, 1 = lowest stigma
replace SSOSH3num = 5 if trim(selfstigma3) == "Agree strongly"
replace SSOSH3num = 4 if trim(selfstigma3) == "Agree slightly"
replace SSOSH3num = 3 if trim(selfstigma3) == "Neither agree nor disagree"
replace SSOSH3num = 2 if trim(selfstigma3) == "Disagree slightly"
replace SSOSH3num = 1 if trim(selfstigma3) == "Disagree strongly"

gen SSOSH_sum = .
replace SSOSH_sum = SSOSH1num + SSOSH2num + SSOSH3num

************************************************************************************
**# Bookmark #2
*PSOSH-5
************************************************************************************

gen PSOSH1num = .
replace PSOSH1num = 5 if trim(publicstigma1) == "Agree strongly"
replace PSOSH1num = 4 if trim(publicstigma1) == "Agree slightly"
replace PSOSH1num = 3 if trim(publicstigma1) == "Neither agree nor disagree"
replace PSOSH1num = 2 if trim(publicstigma1) == "Disagree slightly"
replace PSOSH1num = 1 if trim(publicstigma1) == "Disagree strongly"

gen PSOSH2num = .
replace PSOSH2num = 5 if trim(publicstigma2) == "Agree strongly"
replace PSOSH2num = 4 if trim(publicstigma2) == "Agree slightly"
replace PSOSH2num = 3 if trim(publicstigma2) == "Neither agree nor disagree"
replace PSOSH2num = 2 if trim(publicstigma2) == "Disagree slightly"
replace PSOSH2num = 1 if trim(publicstigma2) == "Disagree strongly"

gen PSOSH3num = .
replace PSOSH3num = 5 if trim(publicstigma3) == "Agree strongly"
replace PSOSH3num = 4 if trim(publicstigma3) == "Agree slightly"
replace PSOSH3num = 3 if trim(publicstigma3) == "Neither agree nor disagree"
replace PSOSH3num = 2 if trim(publicstigma3) == "Disagree slightly"
replace PSOSH3num = 1 if trim(publicstigma3) == "Disagree strongly"

gen PSOSH4num = .
replace PSOSH4num = 5 if trim(publicstigma4) == "Agree strongly"
replace PSOSH4num = 4 if trim(publicstigma4) == "Agree slightly"
replace PSOSH4num = 3 if trim(publicstigma4) == "Neither agree nor disagree"
replace PSOSH4num = 2 if trim(publicstigma4) == "Disagree slightly"
replace PSOSH4num = 1 if trim(publicstigma4) == "Disagree strongly"

gen PSOSH5num = .
replace PSOSH5num = 5 if trim(publicstigma5) == "Agree strongly"
replace PSOSH5num = 4 if trim(publicstigma5) == "Agree slightly"
replace PSOSH5num = 3 if trim(publicstigma5) == "Neither agree nor disagree"
replace PSOSH5num = 2 if trim(publicstigma5) == "Disagree slightly"
replace PSOSH5num = 1 if trim(publicstigma5) == "Disagree strongly"

gen PSOSH_sum = .
replace PSOSH_sum = PSOSH1num + PSOSH2num + PSOSH3num +PSOSH4num + PSOSH5num


************************************************************************************
**# Bookmark #3
*SELF-ESTEEM
************************************************************************************

gen esteem1num = .
*1= low esteem, 5= high esteem
replace esteem1num = 1 if trim(esteem1) == "Disagree strongly"
replace esteem1num = 2 if trim(esteem1) == "Disagree slightly"
replace esteem1num = 3 if trim(esteem1) == "Neither agree nor disagree"
replace esteem1num = 4 if trim(esteem1) == "Agree slightly"
replace esteem1num = 5 if trim(esteem1) == "Agree strongly"

gen esteem2num = .
*1= low esteem, 5= high esteem
replace esteem2num = 1 if trim(esteem2) == "Disagree strongly"
replace esteem2num = 2 if trim(esteem2) == "Disagree slightly"
replace esteem2num = 3 if trim(esteem2) == "Neither agree nor disagree"
replace esteem2num = 4 if trim(esteem2) == "Agree slightly"
replace esteem2num = 5 if trim(esteem2) == "Agree strongly"

gen esteem3num = .
*1= low esteem, 5= high esteem
replace esteem3num = 1 if trim(esteem3) == "Disagree strongly"
replace esteem3num = 2 if trim(esteem3) == "Disagree slightly"
replace esteem3num = 3 if trim(esteem3) == "Neither agree nor disagree"
replace esteem3num = 4 if trim(esteem3) == "Agree slightly"
replace esteem3num = 5 if trim(esteem3) == "Agree strongly"

gen esteem4num = .
*1= low esteem, 5= high esteem
replace esteem4num = 1 if trim(esteem4) == "Disagree strongly"
replace esteem4num = 2 if trim(esteem4) == "Disagree slightly"
replace esteem4num = 3 if trim(esteem4) == "Neither agree nor disagree"
replace esteem4num = 4 if trim(esteem4) == "Agree slightly"
replace esteem4num = 5 if trim(esteem4) == "Agree strongly"

gen esteem5num = .
*1= low esteem, 5= high esteem
replace esteem5num = 1 if trim(esteem5) == "Disagree strongly"
replace esteem5num = 2 if trim(esteem5) == "Disagree slightly"
replace esteem5num = 3 if trim(esteem5) == "Neither agree nor disagree"
replace esteem5num = 4 if trim(esteem5) == "Agree slightly"
replace esteem5num = 5 if trim(esteem5) == "Agree strongly"

gen esteemsum = .
replace esteemsum = esteem1num + esteem2num + esteem3num + esteem4num + esteem5num

************************************************************************************
**# Bookmark #5

*AMI QUESTIONS - ESTIMATES OF OTHERS'S STIGMA

*GETTING ANSWERS TO THE PLURALISTIC IGNORANCE QS.

************************************************************************************

*1. Mental illness is an illness like any other

gen estimated_others_answer1_num = .
gen str50 op1_clean = substr(otherpeople1, 2, length(otherpeople1) - 2)

replace estimated_others_answer1_num = 1 if op1_clean == "Disagree strongly"
replace estimated_others_answer1_num = 2 if op1_clean == "Disagree slightly"
replace estimated_others_answer1_num = 3 if op1_clean == "Neither agree nor disagree"
replace estimated_others_answer1_num = 4 if op1_clean == "Agree slightly"
replace estimated_others_answer1_num = 5 if op1_clean == "Agree strongly"

*2. We have a responsibility to provide the best possible care for people with mental illness

gen estimated_others_answer2_num = .
gen str50 op2_clean = substr(otherpeople2, 2, length(otherpeople2) - 2)

replace estimated_others_answer2_num = 1 if op2_clean == "Disagree strongly"
replace estimated_others_answer2_num = 2 if op2_clean == "Disagree slightly"
replace estimated_others_answer2_num = 3 if op2_clean == "Neither agree nor disagree"
replace estimated_others_answer2_num = 4 if op2_clean == "Agree slightly"
replace estimated_others_answer2_num = 5 if op2_clean == "Agree strongly"

*3. One of the main causes of mental illness is a lack of self-discipline and will power

gen estimated_others_answer3_num = .
gen str50 op3_clean = substr(otherpeople3, 2, length(otherpeople3) - 2)

replace estimated_others_answer3_num = 1 if op3_clean == "Disagree strongly"
replace estimated_others_answer3_num = 2 if op3_clean == "Disagree slightly"
replace estimated_others_answer3_num = 3 if op3_clean == "Neither agree nor disagree"
replace estimated_others_answer3_num = 4 if op3_clean == "Agree slightly"
replace estimated_others_answer3_num = 5 if op3_clean == "Agree strongly"

**4. Virtually anyone can become mentally ill

gen estimated_others_answer4_num = .
gen str50 op4_clean = substr(otherpeople4, 2, length(otherpeople4) - 2)

replace estimated_others_answer4_num = 1 if op4_clean == "Disagree strongly"
replace estimated_others_answer4_num = 2 if op4_clean == "Disagree slightly"
replace estimated_others_answer4_num = 3 if op4_clean == "Neither agree nor disagree"
replace estimated_others_answer4_num = 4 if op4_clean == "Agree slightly"
replace estimated_others_answer4_num = 5 if op4_clean == "Agree strongly"

* REVERSE CODED ALSO NUMBER Q5. There are sufficient existing services for people with mental illness - strongly agree is the MOST stigmatised answer so =5

gen estimated_others_answer5_num = .
gen str50 op5_clean = substr(otherpeople5, 2, length(otherpeople5) - 2)

replace estimated_others_answer5_num = 1 if op5_clean == "Disagree strongly"
replace estimated_others_answer5_num = 2 if op5_clean == "Disagree slightly"
replace estimated_others_answer5_num = 3 if op5_clean == "Neither agree nor disagree"
replace estimated_others_answer5_num = 4 if op5_clean == "Agree slightly"
replace estimated_others_answer5_num = 5 if op5_clean == "Agree strongly"



************************************************************************************
**# Bookmark #6

*"total stigma" across all 5 cami items questions calculations
*q3 and q5 have the highest stigma at "agree strongly"

************************************************************************************

*Q1 mental illness is an illness like any other: disagree strongly is the MOST stigmatised answer so =5

gen otherstotalstigma1 = .

replace otherstotalstigma1 = 5 if op1_clean == "Disagree strongly"
replace otherstotalstigma1 = 4 if op1_clean == "Disagree slightly"
replace otherstotalstigma1 = 3 if op1_clean == "Neither agree nor disagree"
replace otherstotalstigma1 = 2 if op1_clean == "Agree slightly"
replace otherstotalstigma1 = 1 if op1_clean == "Agree strongly"

*Q2 2. We have a responsibility to provide the best possible care for people with mental illness: disagree strongly is the MOST stigmatised answer so =5

gen otherstotalstigma2 = .

replace otherstotalstigma2 = 5 if op2_clean == "Disagree strongly"
replace otherstotalstigma2 = 4 if op2_clean == "Disagree slightly"
replace otherstotalstigma2 = 3 if op2_clean == "Neither agree nor disagree"
replace otherstotalstigma2 = 2 if op2_clean == "Agree slightly"
replace otherstotalstigma2 = 1 if op2_clean == "Agree strongly"

*REVERSE CODED NUMBER 3  3. One of the main causes of mental illness is a lack of self-discipline and will power strongly agree is the MOST stigmatised answer so =5

gen otherstotalstigma3 = .

replace otherstotalstigma3 = 1 if op3_clean == "Disagree strongly"
replace otherstotalstigma3 = 2 if op3_clean == "Disagree slightly"
replace otherstotalstigma3 = 3 if op3_clean == "Neither agree nor disagree"
replace otherstotalstigma3 = 4 if op3_clean == "Agree slightly"
replace otherstotalstigma3 = 5 if op3_clean == "Agree strongly"

**4. Virtually anyone can become mentally ill: strongly disagree is the MOST stigmatised answer so =5

gen otherstotalstigma4 = .

replace otherstotalstigma4 = 5 if op4_clean == "Disagree strongly"
replace otherstotalstigma4 = 4 if op4_clean == "Disagree slightly"
replace otherstotalstigma4 = 3 if op4_clean == "Neither agree nor disagree"
replace otherstotalstigma4 = 2 if op4_clean == "Agree slightly"
replace otherstotalstigma4 = 1 if op4_clean == "Agree strongly"

* REVERSE CODED ALSO NUMBER Q5. There are sufficient existing services for people with mental illness - strongly agree is the MOST stigmatised answer so =5

gen otherstotalstigma5 = .

replace otherstotalstigma5 = 1 if op5_clean == "Disagree strongly"
replace otherstotalstigma5 = 2 if op5_clean == "Disagree slightly"
replace otherstotalstigma5 = 3 if op5_clean == "Neither agree nor disagree"
replace otherstotalstigma5 = 4 if op5_clean == "Agree slightly"
replace otherstotalstigma5 = 5 if op5_clean == "Agree strongly"


gen estimated_others_stigma_sum = .
replace estimated_others_stigma_sum = otherstotalstigma1 + otherstotalstigma2 + otherstotalstigma3 + otherstotalstigma4 + otherstotalstigma5


************************************************************************************
**# Bookmark #6
*AMI QUESTIONS - OWN BELIEFS STIGMA
************************************************************************************

*Q1 mental illness is an illness like any other

gen ownanwer1_num = .

replace ownanwer1_num = 1 if trim(yourself1) == "Disagree strongly"
replace ownanwer1_num = 2 if trim(yourself1) == "Disagree slightly"
replace ownanwer1_num = 3 if trim(yourself1) == "Neither agree nor disagree"
replace ownanwer1_num = 4 if trim(yourself1) == "Agree slightly"
replace ownanwer1_num = 5 if trim(yourself1) == "Agree strongly"
	

*Q2 2. We have a responsibility to provide the best possible care for people with mental illness

gen ownanwer2_num = .

replace ownanwer2_num = 1 if trim(yourself2) == "Disagree strongly"
replace ownanwer2_num = 2 if trim(yourself2) == "Disagree slightly"
replace ownanwer2_num = 3 if trim(yourself2) == "Neither agree nor disagree"
replace ownanwer2_num = 4 if trim(yourself2) == "Agree slightly"
replace ownanwer2_num = 5 if trim(yourself2) == "Agree strongly"

*3. One of the main causes of mental illness is a lack of self-discipline and will power

gen ownanwer3_num = .

replace ownanwer3_num = 1 if trim(yourself3) == "Disagree strongly"
replace ownanwer3_num = 2 if trim(yourself3) == "Disagree slightly"
replace ownanwer3_num = 3 if trim(yourself3) == "Neither agree nor disagree"
replace ownanwer3_num = 4 if trim(yourself3) == "Agree slightly"
replace ownanwer3_num = 5 if trim(yourself3) == "Agree strongly"

**4. Virtually anyone can become mentally ill

gen ownanwer4_num = .

replace ownanwer4_num = 1 if trim(yourself4) == "Disagree strongly"
replace ownanwer4_num = 2 if trim(yourself4) == "Disagree slightly"
replace ownanwer4_num = 3 if trim(yourself4) == "Neither agree nor disagree"
replace ownanwer4_num = 4 if trim(yourself4) == "Agree slightly"
replace ownanwer4_num = 5 if trim(yourself4) == "Agree strongly"

*There are sufficient existing services for people with mental illness

gen ownanwer5_num = .

replace ownanwer5_num = 1 if trim(yourself5) == "Disagree strongly"
replace ownanwer5_num = 2 if trim(yourself5) == "Disagree slightly"
replace ownanwer5_num = 3 if trim(yourself5) == "Neither agree nor disagree"
replace ownanwer5_num = 4 if trim(yourself5) == "Agree slightly"
replace ownanwer5_num = 5 if trim(yourself5) == "Agree strongly"


************************************************************************************
*AMI QUESTIONS - OWN BELIEFS STIGMA
************************************************************************************

*Q1 mental illness is an illness like any other: disagree strongly is the MOST stigmatised answer so =5

gen ownstigma1_num = .

replace ownstigma1_num = 5 if trim(yourself1) == "Disagree strongly"
replace ownstigma1_num = 4 if trim(yourself1) == "Disagree slightly"
replace ownstigma1_num = 3 if trim(yourself1) == "Neither agree nor disagree"
replace ownstigma1_num = 2 if trim(yourself1) == "Agree slightly"
replace ownstigma1_num = 1 if trim(yourself1) == "Agree strongly"

*Q2 2. We have a responsibility to provide the best possible care for people with mental illness: disagree strongly is the MOST stigmatised answer so =5

gen ownstigma2_num = .

replace ownstigma2_num = 5 if trim(yourself2) == "Disagree strongly"
replace ownstigma2_num = 4 if trim(yourself2) == "Disagree slightly"
replace ownstigma2_num = 3 if trim(yourself2) == "Neither agree nor disagree"
replace ownstigma2_num = 2 if trim(yourself2) == "Agree slightly"
replace ownstigma2_num = 1 if trim(yourself2) == "Agree strongly"

*REVERSE CODED NUMBER 3  3. One of the main causes of mental illness is a lack of self-discipline and will power strongly agree is the MOST stigmatised answer so =5

gen ownstigma3_num = .

replace ownstigma3_num = 1 if trim(yourself3) == "Disagree strongly"
replace ownstigma3_num = 2 if trim(yourself3) == "Disagree slightly"
replace ownstigma3_num = 3 if trim(yourself3) == "Neither agree nor disagree"
replace ownstigma3_num = 4 if trim(yourself3) == "Agree slightly"
replace ownstigma3_num = 5 if trim(yourself3) == "Agree strongly"

**4. Virtually anyone can become mentally ill: strongly disagree is the MOST stigmatised answer so =5

gen ownstigma4_num = .

replace ownstigma4_num = 5 if trim(yourself4) == "Disagree strongly"
replace ownstigma4_num = 4 if trim(yourself4) == "Disagree slightly"
replace ownstigma4_num = 3 if trim(yourself4) == "Neither agree nor disagree"
replace ownstigma4_num = 2 if trim(yourself4) == "Agree slightly"
replace ownstigma4_num = 1 if trim(yourself4) == "Agree strongly"

* REVERSE CODED ALSO NUMBER Q5. There are sufficient existing services for people with mental illness - strongly agree is the MOST stigmatised answer so =5

gen ownstigma5_num = .

replace ownstigma5_num = 1 if trim(yourself5) == "Disagree strongly"
replace ownstigma5_num = 2 if trim(yourself5) == "Disagree slightly"
replace ownstigma5_num = 3 if trim(yourself5) == "Neither agree nor disagree"
replace ownstigma5_num = 4 if trim(yourself5) == "Agree slightly"
replace ownstigma5_num = 5 if trim(yourself5) == "Agree strongly"

*SUM OF OWN STIGMA

gen ownstigma_sum = .
replace ownstigma_sum = ownstigma1_num + ownstigma2_num + ownstigma3_num + ownstigma4_num + ownstigma5_num

************************************************************************************
**# Bookmark #8
//PLURALISTIC IGNORANCE: WEDGES
************************************************************************************

gen wedge = ownstigma_sum - estimated_others_stigma_sum

gen wedgetrin = .
replace wedgetrin = -1 if wedge <0
replace wedgetrin = 0 if wedge == 0
replace wedgetrin = 1 if wedge >= 1
replace wedgetrin = . if wedge == .

gen wedge_five = .
replace wedge_five = 1 if wedge >= -16 & wedge <= -9  // Hihgest wedge group (N=76)
replace wedge_five = 2 if wedge >= -7 & wedge <= -4   // Middle wedge group (N=76) 
replace wedge_five = 3 if wedge >= -4 & wedge <= -1   // Low wedge group (N=76) 
replace wedge_five = 4 if wedge == 0 // Perfect estimate group, no wedge
replace wedge_five = 5 if wedge >= 1 // Positive wedge group
replace wedge_five = . if wedge == . 

label define wedge_five_lbl 1 "Biggest wedge" 2 "Medium wedge" 3 "Small wedge" 4 "Zero wedge" 5 "Positive wedge"
label values wedge_five wedge_five_lbl 


* Create interaction between treatment and misperception categories
gen treat_X_wedge_five = treatmentgroup * wedge_five

label define treat_X_wedge_five_lbl ///
    0 "Control" ///
    1 "Biggest wedge" ///
    2 "Medium wedge" ///
    3 "Small wedge" ///
	4 "Zero wedge" ///
	5 "Positive wedge" ///
	
label values treat_X_wedge_five treat_X_wedge_five_lbl

************************************************************************************
**# Bookmark #9
*LIKELIHOOD OF GOING TO THE GP
************************************************************************************
*tab gplikely

gen gplikely_num = .
replace gplikely_num = 1 if trim(gplikely) == "Very unlikely"
replace gplikely_num = 2 if trim(gplikely) == "Quite unlikely"
replace gplikely_num = 3 if trim(gplikely) == "Neither likely nor unlikely"
replace gplikely_num = 4 if trim(gplikely) == "Quite likely"
replace gplikely_num = 5 if trim(gplikely) == "Very likely"

gen gplikely_binary = .
replace gplikely_binary = 1 if gplikely_num == 5
replace gplikely_binary = 1 if gplikely_num == 4

replace gplikely_binary = 0 if gplikely_num == 1
replace gplikely_binary = 0 if gplikely_num == 2


gen friendcomfort_num = .
replace friendcomfort_num = 1 if trim(friendcomfort) == "Very uncomfortable"
replace friendcomfort_num = 2 if trim(friendcomfort) == "Moderately uncomfortable"
replace friendcomfort_num = 3 if trim(friendcomfort) == "Slightly uncomfortable"
replace friendcomfort_num = 4 if trim(friendcomfort) == "Neither comfortable nor uncomfortable"
replace friendcomfort_num = 5 if trim(friendcomfort) == "Fairly comfortable"
replace friendcomfort_num = 6 if trim(friendcomfort) == "Moderately comfortable"
replace friendcomfort_num = 7 if trim(friendcomfort) == "Very comfortable"


gen employercomfort_num = .
replace employercomfort_num = 1 if trim(employercomfort) == "Very uncomfortable"
replace employercomfort_num = 2 if trim(employercomfort) == "Moderately uncomfortable"
replace employercomfort_num = 3 if trim(employercomfort) == "Slightly uncomfortable"
replace employercomfort_num = 4 if trim(employercomfort) == "Neither comfortable nor uncomfortable"
replace employercomfort_num = 5 if trim(employercomfort) == "Fairly comfortable"
replace employercomfort_num = 6 if trim(employercomfort) == "Moderately comfortable"
replace employercomfort_num = 7 if trim(employercomfort) == "Very comfortable"

