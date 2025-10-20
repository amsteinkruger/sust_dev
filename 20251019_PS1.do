* AEC 640, Problem Set 1

use "data/DJO2012.dta"

summarize

* Summary Statistics

*  (1)

twoway qfitci g year
graph export "out/20251019_PS1_1.png", width(600) height(400) as(png) replace

twoway qfitci wtem year
graph export "out/20251019_PS1_2.png", width(600) height(400) as(png) replace

*  (2)

twoway lfit g wtem if poor == 0, saving(summary_2_1)
twoway lfit g wtem if poor == 1, saving(summary_2_2)

gr combine summary_2_1.gph summary_2_2.gph, ycommon

graph export "out/20251019_PS1_3.png", width(750) height(500) as(png) replace

* Regressions

*  OLS

*   (1)

*    (a)

eststo reg_2_1_a: reg g wtem year

*    (b)

eststo reg_2_1_b: reg g wtem c.wtem#i.poor year

*    (c)

eststo reg_2_1_c: reg g wtem i.year

esttab reg_2_1_a reg_2_1_b reg_2_1_c, indicate("Year FE = *.year")

*   (2) (Interpret)

*  FE OLS

*   (1)

*    (a)

reg g year
predict residuals_3_1_a_1, residuals
reg wtem year
predict residuals_3_1_a_2, residuals

twoway lfit residuals_3_1_a_1 residuals_3_1_a_2, ///
xtitle("Residuals of Temp. ~ Year") ///
ytitle("Residuals of Growth ~ Year")

graph export "out/20251019_PS1_4.png", width(600) height(400) as(png) replace


*    (b)

reg g i.cc_num year
predict residuals_3_1_b_1, residuals
reg wtem i.cc_num year
predict residuals_3_1_b_2, residuals

twoway lfit residuals_3_1_b_1 residuals_3_1_b_2, ///
xtitle("Residuals of Temp. ~ Year + Country") ///
ytitle("Residuals of Growth ~ Year + Country")

graph export "out/20251019_PS1_5.png", width(600) height(400) as(png) replace

*   (2)

*    (a)

eststo reg_3_2_a: reg g wtem c.wtem#i.poor i.cc_num year

*    (b)

eststo reg_3_2_b: reg g wtem c.wtem#i.poor i.cc_num i.year

*    (c)

eststo reg_3_2_c: reg g wtem c.wtem#i.poor i.poor i.year

*   (3)

esttab reg_3_2_a reg_3_2_b reg_3_2_c, indicate("Country FE = *.cc_num" "Year FE = *.year")

*  Non-Linearities

*   (1)

*    Poor == 0

reg g wtem c.wtem#c.wtem i.year if poor == 0
margins, dydx(wtem) at(wtem = (0(1)30)) post

eststo Rich // reg_4_1_1

*    Poor == 1

reg g wtem c.wtem#c.wtem i.year if poor == 1
margins, dydx(wtem) at(wtem = (0(1)30)) post

eststo Poor // reg_4_1_2

coefplot Rich Poor, ///
at recast(line) ciopts(recast(rline) lpattern(dash)) ///
xtitle("Temperature") ytitle("Marginal Effect on Growth")

graph export "out/20251019_PS1_6.png", width(600) height(400) as(png) replace

*   (2)

egen wtem_bin = cut(wtem), at(0(6)30)

eststo reg_4_2_1: reg g i.wtem_bin if poor == 0
eststo reg_4_2_2: reg g i.wtem_bin if poor == 1
esttab reg_4_2_1 reg_4_2_2

*   (3)

eststo reg_4_3: reg g c.wtem##c.wpre i.cc_num i.year

esttab reg_4_3, indicate("Country FE = *.cc_num" "Year FE = *.year") 
