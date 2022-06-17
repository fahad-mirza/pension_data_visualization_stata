	* Input the required data
  
  clear
	input byte year double(civ_pen_totexp mil_pen_totexp)
	 1  .73 2.81
	 2  .83 2.65
	 3  .96 3.07
	 4  .97 3.33
	 5  1.2  3.8
	 6 1.27 3.92
	 7 1.38 3.63
	 8 1.33 3.53
	 9 1.39 4.38
	10 1.14 3.97
	11 1.56 5.03
	12 1.41 4.24
	13 1.42 4.16
	end
	label values year year
	label def year 1 "2010-11", modify
	label def year 2 "2011-12", modify
	label def year 3 "2012-13", modify
	label def year 4 "2013-14", modify
	label def year 5 "2014-15", modify
	label def year 6 "2015-16", modify
	label def year 7 "2016-17", modify
	label def year 8 "2017-18", modify
	label def year 9 "2018-19", modify
	label def year 10 "2019-20", modify
	label def year 11 "2020-21", modify
	label def year 12 "2021-22", modify
	label def year 13 "2022-23", modify
  
  * Installing necessary packages
  ssc install schemepack, replace
  ssc install palettes, replace
  ssc install colrspace, replace

	* Generating variables to create a minor drop shadow effect
	generate year_shadow = year - 0.14
	generate mil_shadow = mil_pen_totexp - 0.04
	generate civ_shadow = civ_pen_totexp 

	* Saving x-axis labels in local
	quietly: summarize year
	local count = `r(max)'
	local countmin = `r(min)'
 
	local xlab
    forval i=1(2)`count'{
        local xlab "`xlab' `i' `" "`:lab (year) `i''" "'"
    }
	
	* Storing Max value for military and civilian expenditure 
	quietly summ mil_pen_totexp
	local mil_max = `r(max)'
	
	quietly summ civ_pen_totexp
	local civ_max = `r(max)'

	* Plotting the visual
	#delimit ;
	twoway 	
			(scatteri `=`mil_max'+ 0.62' `=11 - 1' `=`mil_max'+ 0.62' `=11 + 1', recast(line) lcolor(gs7))
			(scatteri `=`mil_max'+ 0.25' `=11 - 1' `=`mil_max'+ 0.25' `=11 + 1', recast(line) lcolor(gs7))
			(scatteri `=`mil_max' + 0.45' 11 "`mil_max'%", ms(i) mlabpos(0) mlabsize(4.75) mlabcolor(gs7))
			(scatteri `mil_max' 11 `=`mil_max'+ 0.25' 11, recast(line) lcolor(gs7))
			(scatteri `mil_max' 11, mlabpos(0) msize(5) mcolor(gs7))
			(scatteri `mil_max' 11, mlabpos(0) msize(4) mcolor(white))
			(area mil_shadow year_shadow, lwidth(0) color(black%30))
			(area mil_pen_totexp year, lwidth(0) color("132 158 93"))
			(scatteri `=((3.92-1.27)/2)+1.27' 7 "{bf}Military Pension", ms(i) mlabpos(0) mlabcolor(white))
			
			(scatteri `=`civ_max'+ 0.62' `=11 - 1' `=`civ_max'+ 0.62' `=11 + 1', recast(line) lcolor("31 119 180"))
			(scatteri `=`civ_max'+ 0.25' `=11 - 1' `=`civ_max'+ 0.25' `=11 + 1', recast(line) lcolor("31 119 180"))
			(scatteri `=`civ_max' + 0.45' 11 "`civ_max'%", ms(i) mlabpos(0) mlabsize(4.75) mlabcolor("31 119 180"))
			(scatteri `civ_max' 11 `=`civ_max'+ 0.25' 11, recast(line) lcolor("31 119 180"))
			(scatteri `civ_max' 11, mlabpos(0) msize(5) mcolor("31 119 180"))
			(scatteri `civ_max' 11, mlabpos(0) msize(4) mcolor(white))

			(area civ_shadow year_shadow if year >= 1, lwidth(0) color(black%30))
			(area civ_shadow year_shadow if year_shadow >= 0 & year_shadow <=1, lwidth(0) color(white))
			(area civ_pen_totexp year, lwidth(0) color("31 119 180"))
			(scatteri `=1.38/2' 7 "{bf}Civilian Pension", ms(i) mlabpos(0) mlabcolor(white))
			(scatteri 0 1 0 0.8 4 0.8 4 1, recast(area) lwidth(0) color(white))
			
			(scatter civ_pen_totexp year if year != 11, msize(2) mcolor("31 119 180*1.2"))
			(scatter civ_pen_totexp year if year != 11, msize(1) mcolor(white))
			(scatter mil_pen_totexp year if year != 11, msize(2) mcolor("132 158 93*1.2"))
			(scatter mil_pen_totexp year if year != 11, msize(1) mcolor(white))
			
			(scatteri `=civ_pen_totexp[1]' `=`countmin'-0.6' "0`=civ_pen_totexp[1]'%", ms(i) mlabpos(0))
			(scatteri `=mil_pen_totexp[1]' `=`countmin'-0.6' "`=mil_pen_totexp[1]'%", ms(i) mlabpos(0))
			(scatteri `=civ_pen_totexp[`=_N']' `=`count'+0.65' "`=civ_pen_totexp[`=_N']'%", ms(i) mlabpos(0))
			(scatteri `=mil_pen_totexp[`=_N']' `=`count'+0.65' "`=mil_pen_totexp[`=_N']'%", ms(i) mlabpos(0))
			
			(scatteri 3.5 -4 "{bf}PENSION COMPARISON", ms(i) mlabpos(0) mlabsize(3) mlabcolor(gs4))
			(scatteri 3.27 -4 "As a % of Total Expenditure", ms(i) mlabpos(0) mlabsize(2.85) mlabcolor(gs4))
			(scatteri 3.8 `=-4 - 2.5' 3.8 `=-4 + 2.5', recast(line) lcolor(gs4))
			(scatteri 3 `=-4 - 2.5' 3 `=-4 + 2.5', recast(line) lcolor(gs4))

			, 
			legend(off)
			note("Source: Federal Govt. Budget Briefs FY 2011-23", size(*.65) margin(t = 4 l = 4) span)
			xscale(range(-7 ) noline)
			xlabel(`xlab', valuelabel labsize(*0.75) nogrid) 
			xtitle("") 
			ylabel(, nogrid)
			ytitle("")
			yscale(range(0 ) off)
			plotregion(margin(b = 0))
			scheme(white_tableau)
	;
	#delimit cr
	
	* Saving the final output
	graph export "./graph.png", as(png) width(3840) replace
