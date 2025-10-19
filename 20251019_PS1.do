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

*  Basic OLS

*   (1)

