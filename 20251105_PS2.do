* AEC 640, Problem Set 2

use "data/ecological_footprint_restat_deforestation_data.dta"

summarize

* (1)

*  (2-4) in R.

*  (5)

drop if indice95 < -2.00
drop if indice95 > -0.20

gen simple = 0
replace simple = 1 if indice95 > -1.22

* table w/ 
* simple RD, no controls
* simple RD, w/ controls
* fuzzy RD w/ controls including linear running var
* fuzzy RD including controls w/ quadratic running var (no linear running var?)

quietly rdrobust cod_sa_poisoning agemo_mda, p(1) kernel(triangular) covs(firstmonth) 

* Reference code

quietly rdrobust cod_sa_poisoning agemo_mda, p(1) kernel(triangular) covs(firstmonth) 

*  (6)

* Test for discontinuities in three controls (after assumptions piece)

* (2)

*  (1)

* just this one to pull numbers, do arithmetic, and handle SD?

*  (2)

*  (3)