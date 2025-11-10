* AEC 640, Problem Set 2

clear all

use "data/ecological_footprint_restat_deforestation_data.dta"

summarize

gen pctdefor_100 = pctdefor * 100 // Correct scale.
* replace perforestK = . if perforestK > 100 // Clean out nonsense values. Commented out for consistency.
* gen lnlnslope = ln(lnslope) // Correct form. Commented out for consistency.
gen marginality_window = 0
replace marginality_window = 1 if indice95 < -0.9 & indice95 > -1.2

vl create controls = (perforestK lnarea lnpob lnslope lcarcon) // Set up controls. ecoreg* omitted for consistency.

* (1)

*  (1)
*  (2)
*  (3)

drop if indice95 < -2.00
drop if indice95 > -0.20

*  (4)
*  (5)

eststo reg_5_1: tobit pctdefor_100 eligible99 indice95, ll(0) ul(100) vce(robust)
eststo reg_5_2: tobit pctdefor_100 eligible99 indice95 $controls, ll(0) ul(100) vce(robust)
eststo reg_5_3: ivtobit pctdefor_100 (treat = i.eligible99##c.indice95 marginality_window $controls) indice95 $controls, ll(0) ul(100) vce(robust)
eststo reg_5_4: ivtobit pctdefor_100 (treat = i.eligible99##c.indice95 ind2 marginality_window $controls) indice95 ind2 $controls, ll(0) ul(100) vce(robust)

esttab reg_5_1 reg_5_2 reg_5_3 reg_5_4 using PS2_1_5.rtf, star(* 0.10 ** 0.05 *** 0.01) replace

*  (6)

* Try some scatterplots.

scatter perforestK indice95
scatter lnarea indice95
scatter lnpob indice95
scatter lnslope indice95
scatter lcarcon indice95

* Try some simple RD models.

eststo reg_6_1: reg perforestK eligible99 indice95
eststo reg_6_2: reg lnarea eligible99 indice95
eststo reg_6_3: reg lnpob eligible99 indice95
eststo reg_6_4: reg lnslope eligible99 indice95
eststo reg_6_5: reg lcarcon eligible99 indice95

esttab reg_6_1 reg_6_2 reg_6_3 reg_6_4 reg_6_5 using PS2_1_6.rtf, star(* 0.10 ** 0.05 *** 0.01) replace

* (2)

*  (1)

sum pctdefor_100 // Get SD.

sum eligible99 // Get proportion of sample treated.

*  (2)

*  (3)