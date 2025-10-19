* AEC 640, Problem Set 1

use "data/DJO2012.dta"

summarize


* Summary Statistics

*  (1)

twoway qfitci g year
twoway qfit wtem year
twoway qfit wtem wpre

*  (2)

twoway lfit g wtem if poor == 0
twoway lfit g wtem if poor == 1

* Remember to set common scale for the two panels. Add points.

* Regressions

*  OLS

*   (1)

*    (a)

reg g wtem year

*    (b)

reg g wtem c.wtem#i.poor year

*    (c)

reg g wtem i.year

*   (2) (Interpret)

*  FE OLS

*   (1)

*    (a)

reg g year
reg wtem year

* (Should be year not i.year?)

* Save residuals
* Graph residuals

*    (b)

reg g i.cc_num year
reg wtem i.cc_num year

* Save residuals
* Graph residuals

*   (2)

* xtset // Guess not? Check (b) against xtreg results before sticking with reg.

*    (a)

reg g wtem c.wtem#i.poor i.cc_num year

*    (b)

reg g wtem c.wtem#i.poor i.cc_num i.year

*    (c)

reg g wtem c.wtem#i.poor i.poor i.year

*   (3) (Tabulate)

*  Non-Linearities

*   (1)

reg g wtem c.wtem#c.wtem i.year if poor = 0
reg g wtem c.wtem#c.wtem i.year if poor = 1

* coefplot for ME
* Calculations (1)
* Calculations (2)
* Interpret

*   (2)

* egen / cut two sets of bins no temperature, one for rich, one for poor

reg g wtem_bin_0 if poor = 0
reg g wtem_bin_1 if poor = 1

* Interpret w/ omitted category

*   (3)

reg g c.wtem##c.wpre i.cc_num i.year

* Interpet