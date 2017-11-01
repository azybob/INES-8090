/*Import file under Mosaic Computer environment*/
proc import out = work.a_2 datafile = 'W:\Documents\HW Assignments\INES 8090\Assignment\Assignment2.xlsx' dbms = xlsx;
/*Import file under SAS Studio Environment*/
/*proc import datafile = '/home/yl700/Data/Assignment2.xlsx' dbms = xlsx out = work.a_2;*/
/*Import file under Citrix Remote Access environment*/
/*proc import out = work.a_2 datafile = '\\client\D$\Google Drive\INES 8090\Assignment\Assignment2.xlsx' dbms = xlsx;*/
run;

/*Create formats of the variables, in order to show the analysis results more readibly*/
proc format;
	value alts 1 = 'Drive-alone' 2 = 'Shared Ride' 3 = 'Transit';
run;

/*proc sql;
	create table Mode_Share as select alt label = 'Mode' format = alts., sum(chosen) as Sum
	from a_2
	group by alt
	order by alt;
	alter table Mode_share
		add m_s num label = 'Mode Share';
	select alt, Sum, m_s from Mode_Share;
*/

/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*Question 1*/
/*Question 1_a*/
/*Create table of sample mode frequency*/
proc sql;
	create table s_s as
	select alt,
			sum(chosen) as Frequency
		from a_2
		group by alt
		order by alt;

/*Create table of sample mode share*/
proc sql;
	create table m_s as
	select alt, Frequency, Frequency/sum(Frequency) as ss format = percentn10.2
		from s_s;
quit;

/*Print sample mode share*/
proc print data = m_s label;
	label alt = 'Mode' ss = 'Mode Sample Share';
	format alt alts.;
	title 'Mode Share from The Sample';
run;

/*Add one column corresponding to true market share*/
data m_s2;
	set m_s;
	if alt = 1 then mks = 0.7655;
	else if alt = 2 then mks = 0.1131;
	else mks = 0.1214;
	format mks percentn10.2;
run;

/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*Question 1_b*/
/*Create table to calculate weight corresponding to market share*/
proc sql;
	create table wm_s2 as
	select alt, frequency, ss, mks, mks/ss as weight format = 10.4
		from m_s2;
quit;

/*Print sample mode share*/
proc print data = wm_s2 label;
	label alt = 'Mode' ss = 'Sample Share' mks = 'Market Share';
	format alt alts.;
	title 'Weight = Market Share / Sample Share';
run;

/*Question 1_c*/
/*Logit(C) without weight variable
proc mdc data = a_2;
	title 'The Constant-Only Logit Model (without weight)';
	model chosen = unosr unotr /
		type = clogit
		choice = (alt)
		covest = hess
		optmethod = qn;
	id case;
run;

/*Question 1_d*/
/*Logit(C) with weight variable
proc logistic data = a_2;
	title 'The Constant-Only Logit Model (with weight)';
	model chosen (event = '1')= unoda unotr unosr / noint;
	weight weight;
	output out=new P= option;
run;

proc logistic data = a_2;
	title 'The Constant-Only Logit Model (with weight)';
	model chosen (event = '1') = unosr unotr / noint link = logit;
	weight weight;
	output out=new P= option;
run;*/

title;

/*Create a dummy var 'failure' to be the censored var to chosen*/
data a_2;
set a_2;
failure = 1-chosen;
run;

/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*Question 1_c*/
/*Logit(C) without weight variable using 'phreg'*/
proc phreg data = a_2 nosummary outest = betas_0;
strata case;
model failure*chosen (0) = unosr unotr ;
title 'Constant-Only Logit Model without Weight';
run;

/*The following stpes calculate the probabilities of each alternatives within each case*/
/*1. using the betas_0 and the corresponding vars(unosr and unotr) to calculate the utilities*/
proc score data = a_2 score = betas_0 type = parms out = p;
	var unosr unotr;
run;

/*2. exponentiate each utility*/
data p (rename = (failure2 = ut));
set p;
run;
data p;
set p;
label ut = 'utility';
p = exp(ut);
run;

/*3. sum up the total utility for each case*/
proc means data = p noprint;
	output out = s sum(p) = sp;
	by case;
run;

/*4. merge two data set and calculate the probability of each alternative within each case*/
data p;
	merge p s(keep = case sp);
	by case;
	p = p / sp;
run;

/*5. Create a table to show the average choice probability of each mode*/
proc sql;
create table v_m_wo_w as select alt, sum(p*chosen) as tp, sum(chosen) as tf from p group by alt;
quit;

data v_m_wo_w;
set v_m_wo_w;
format alt alts.;
v_m_wo_w = tp/tf;
run;

data v_m_wo_w;
set v_m_wo_w /*(drop = ss tt)*/;
format v_m_wo_w percent10.2;
run;

/*6. Create a table to show the verification*/
proc print data = v_m_wo_w label;
	label alt = 'Mode' v_m_wo_w = 'Verified Sample Share' tp = 'Total Probability of Each Mode'  tf = 'Total Frequency of Each Mode';
	format alt alts.;
	title 'Verified Sample Share = Total Probability of Each Mode / Total Frequency of Each Mode';
run;

/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*Question 1_d*/
/*Logit(C) with weight variable using 'phreg'*/
proc phreg data = a_2 nosummary outest = betas_1;
strata case;
model failure*chosen (0) = unosr unotr ;
weight weight;
title 'Constant-Only Logit Model with Weight';
run;

/*The following stpes calculate the probabilities of each alternatives within each case*/
/*1. using the betas_0 and the corresponding vars(unosr and unotr) to calculate the utilities*/
proc score data = a_2 score = betas_1 type = parms out = p_1;
	var unosr unotr;
run;

/*2. exponentiate each utility*/
data p_1 (rename = (failure2 = ut));
set p_1;
run;

data p_1;
set p_1;
label ut = 'utility';
p = exp(ut);
run;

/*3. sum up the total utility for each case*/
proc means data = p_1 noprint;
	output out = s_1 sum(p) = sp;
	by case;
run;

/*4. merge two data set and calculate the probability of each alternative within each case*/
data p_1;
	merge p_1 s_1(keep = case sp);
	by case;
	p = p / sp;
run;

/*5. Create a table to show the average choice probability of each mode*/
proc sql;
create table v_m_wo_w_1 as select alt, sum(p*chosen) as tp, sum(chosen) as tf from p_1 group by alt;
quit;

data v_m_wo_w_1;
set v_m_wo_w_1;
format alt alts.;
v_m_wo_w = tp/tf;
run;

data v_m_wo_w_1;
set v_m_wo_w_1 /*(drop = ss tt)*/;
format v_m_wo_w percent10.2;
run;

/*6. Create a table to show the verification*/
proc print data = v_m_wo_w_1 label;
	label alt = 'Mode' v_m_wo_w = 'Verified Sample Share' tp = 'Total Probability of Each Mode'  tf = 'Total Frequency of Each Mode';
	format alt alts.;
	title 'Verified Sample Share with Weight = Total Probability of Each Mode / Total Frequency of Each Mode';
run;

title;

/*--------------------------------------------------------------------------------------------------------------------------------------*/

