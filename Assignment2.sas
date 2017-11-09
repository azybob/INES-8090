/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------Data Preparation-------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*Import file under Mosaic Computer environment*/
/*proc import out = work.a_2 datafile = 'W:\Documents\HW Assignments\INES 8090\Assignment\Assignment2.xlsx' dbms = xlsx;*/
/*Import file under SAS Studio Environment*/
/*proc import datafile = '/home/yl700/Data/Assignment2.xlsx' dbms = xlsx out = work.a_2;*/
/*Import file under Citrix Remote Access environment*/
/*proc import out = work.a_2 datafile = '\\client\D$\Google Drive\INES 8090\Assignment\Assignment2.xlsx' dbms = xlsx;*/
/*Import file under My Own Computer environment*/
proc import out = work.a_2 datafile = 'D:\Google Drive\INES 8090\Assignment\Assignment2.xlsx' dbms = xlsx;
run;

/*Create formats of the variables, in order to show the analysis results more readibly*/
proc format;
	value alts 1 = 'Drive-alone' 2 = 'Shared Ride' 3 = 'Transit';
run;

/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------Question 1--------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------Question 1 a-------------------------------------------------------------*/
/*Create table of sample mode frequency*/
proc sql;
	create table s_s as
	select alt,
			sum(chosen) as Frequency
		from a_2
		group by alt;
		order by alt;

/*Create table of sample mode share*/
proc sql;
	create table m_s as
	select alt, Frequency, Frequency/sum(Frequency) as ss format = percentn10.2
		from s_s;
quit;

/*Print sample mode share*/
proc print data = m_s label noobs;
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

/*-------------------------------------------------------------Question 1 b-------------------------------------------------------------*/
/*Create table to calculate weight corresponding to market share*/
proc sql;
	create table wm_s2 as
	select alt, frequency, ss, mks, mks/ss as weight format = 10.4
		from m_s2;
quit;

/*Print sample mode share*/
proc print data = wm_s2 label noobs;
	label alt = 'Mode' ss = 'Sample Share' mks = 'Market Share';
	format alt alts.;
	title 'Weight = Market Share / Sample Share';
run;

title;

/*-------------------------------------------------------------Question 1 c-------------------------------------------------------------*/

/*Create a dummy var 'failure' to be the censored var to chosen*/
data a_2;
set a_2;
failure = 1-chosen;
run;

/*Logit(C) without weight variable using 'phreg'*/
proc phreg data = a_2 nosummary outest = betas_1_c;
strata case;
model failure*chosen (0) = unosr unotr ;
title 'Constant-Only Logit Model without Weight';
run;

/*The following stpes calculate the probabilities of each alternatives within each case*/
/*1. using the betas_0 and the corresponding vars(unosr and unotr) to calculate the utilities*/
proc score data = a_2 score = betas_1_c type = parms out = p_1_c;
	var unosr unotr;
run;

/*2. exponentiate each utility*/
data p_1_c (rename = (failure2 = ut));
set p_1_c;
run;
data p_1_c;
set p_1_c;
label ut = 'utility';
p = exp(ut);
run;

/*3. sum up the total utility for each case*/
proc means data = p_1_c noprint;
	output out = s_1_c sum(p) = sp;
	by case;
run;

/*4. merge two data set and calculate the probability of each alternative within each case*/
data p_1_c;
	merge p_1_c s_1_c(keep = case sp);
	by case;
	p = p / sp;
run;

/*5. Create a table to show the average choice probability of each mode*/
proc sql;
create table v_m_wo_w_1_c as select alt, sum(p) as tp from p_1_c group by alt;
quit;

data v_m_wo_w_1_c;
set v_m_wo_w_1_c;
format alt alts.;
v_m_wo_w = tp/1125;
run;

data v_m_wo_w_1_c;
set v_m_wo_w_1_c /*(drop = ss tt)*/;
format v_m_wo_w percent10.2;
run;

/*6. Create a table to show the verification*/
proc print data = v_m_wo_w_1_c label noobs;
	label alt = 'Mode' v_m_wo_w = 'Verified Sample Share' tp = 'Total Probability of Each Mode';
	format alt alts.;
	title 'Verified Sample Share (Average Probability) = Total Probability of Each Mode / Case Number (1125)';
run;

/*-------------------------------------------------------------Question 1 d-------------------------------------------------------------*/

/*Logit(C) with weight variable using 'phreg'*/
proc phreg data = a_2 nosummary outest = betas_1_d;
strata case;
model failure*chosen (0) = unosr unotr ;
weight weight;
title 'Constant-Only Logit Model with Weight';
run;

/*The following stpes calculate the probabilities of each alternatives within each case*/
/*1. using the betas_0 and the corresponding vars(unosr and unotr) to calculate the utilities*/
proc score data = a_2 score = betas_1_d type = parms out = p_1_d;
	var unosr unotr;
run;

/*2. exponentiate each utility*/
data p_1_d (rename = (failure2 = ut));
set p_1_d;
run;

data p_1_d;
set p_1_d;
label ut = 'utility';
p = exp(ut);
run;

/*3. sum up the total utility for each case*/
proc means data = p_1_d noprint;
	output out = s_1_d sum(p) = sp;
	by case;
run;

/*4. merge two data set and calculate the probability of each alternative within each case*/
data p_1_d;
	merge p_1_d s_1_d(keep = case sp);
	by case;
	p = p / sp;
run;

/*5. Create a table to show the average choice probability of each mode*/
proc sql;
create table v_m_wo_w_1_d as select alt, sum(p) as tp from p_1_d group by alt;
quit;

data v_m_wo_w_1_d;
set v_m_wo_w_1_d;
format alt alts.;
v_m_wo_w = tp/1125;
run;

data v_m_wo_w_1_d;
set v_m_wo_w_1_d /*(drop = ss tt)*/;
format v_m_wo_w percent10.2;
run;

/*6. Create a table to show the verification*/
proc print data = v_m_wo_w_1_d label noobs;
	label alt = 'Mode' v_m_wo_w = 'Verified Sample Share' tp = 'Total Probability of Each Mode';
	format alt alts.;
	title 'Verified Sample Share with Weight (Average Probability) = Total Probability of Each Mode / Case Number (1125)';
run;

title;

/*-------------------------------------------------------------Question 1 e-------------------------------------------------------------*/
data q_1_e;
set wm_s2;
if alt = 1 then b_wo_w = 0;
else if alt = 2 then b_wo_w = -0.862323811;
else b_wo_w = -0.023733747;
bias = log(ss/mks);
ad_bias = bias - -0.607709482; 
if alt = 1 then ad_bias = 0;
drop weight;
b_w_w = b_wo_w - ad_bias;
drop frequency;
run;

proc print data = q_1_e label noobs;
	label alt = 'Mode' ss = 'Sample Share' mks = 'Market Share' b_wo_w = 'Beta W/O Weight' bias = 'Bias (Sample Share / Market Share)' 
		ad_bias = "Adjusted Bias (Set Base DA's Beta Equal to 0)" b_w_w = 'Beta with Weight';
	format alt alts.;
	title 'Question 1 e)';
run;

/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------Question 2--------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------Question 2 a-------------------------------------------------------------*/

/*Logit(C) with weight variable using 'phreg' (IVTT, OVTTDIST and TOTCOST)*/

/*ods graphics off;
ods exclude all;*/  
proc phreg data = a_2 nosummary outest = betas_2_a;
strata case;
model failure*chosen (0) = unosr unotr ivtt ovttdist totcost;
weight weight;
title 'Logit Model with Weight (IVTT, OVTTDIST and TOTCOST)';
ods output ParameterEstimates = sd_2_a;
run;
ods output close;
/*ods exclude none;*/

data sd_2_a;
set sd_2_a (keep = parameter estimate stderr);
t_value = estimate / stderr;
run;

proc print data = sd_2_a label noobs;
	label parameter = 'Variable' estimate = 'Coefficient (Beta)' t_value = 't stat';
	title 'Significance of Each Coefficient';
run;

title;

/*Calculate the 'Value of In-Vehicle Travel Time ($/hr)' and print it*/
proc sql;
create table Q_2_a as select ivtt/totcost*60 as v_of_ivtt from betas_2_a;
quit;

proc print data = q_2_a label noobs;
	label v_of_ivtt = 'Value of In-Vehicle Travel Time ($/hr)';
	title 'Value of In-Vehicle Travel Time ($/hr)';
run;

/*Plot the 'OVTT-Distance Plot'*/
goptions reset = all;
symbol1 v=star c=red h=1;
symbol2 v=triangle c=blue h=1;
symbol3 v=plus c = green h=1;
proc gplot data = a_2;
  plot ovtt*dist=alt;
  format alt alts.;
title 'OVTT-Distance Plot';
run;
quit;

/*--------------------------------------------------------Question 2 b-------------------------------------------------------------*/

/*Logit(C) with weight variable using 'phreg' (IVTT, OVTTDIST, TOTCOST, VEHWRKSR and VEHWRKTR)*/
/*Record and calculate the t statistic ('Significance Test for Each Coefficient') of each coefficient via 'ODS' and 'DATA'*/

/*ods graphics off;
ods exclude all;*/  
ods output ParameterEstimates = sd_2_b;
proc phreg data = a_2 nosummary outest = betas_2_b;
strata case;
model failure*chosen (0) = unosr unotr ivtt ovttdist totcost vehwrksr vehwrktr;
weight weight;
title 'Logit Model with Weight (IVTT, OVTTDIST, TOTCOST, VEHWRKSR and VEHWRKTR)';
run;
ods output close;
/*ods exclude none;*/

data sd_2_b;
set sd_2_b (keep = parameter estimate stderr);
t_value = estimate / stderr;
run;

proc print data = sd_2_b label noobs;
	label parameter = 'Variable' estimate = 'Coefficient (Beta)' t_value = 't stat';
	title 'Significance of Each Coefficient';
run;

title;

/*-------------------------------------------------------------Question 2 c-------------------------------------------------------------*/

/*Logit(C) with weight variable using 'phreg' (IVTT, OVTTDIST, TOTCOST and VEHWRKDA)*/
/*Record and calculate the t statistic ('Significance Test for Each Coefficient') of each coefficient via 'ODS' and 'DATA'*/

/*ods graphics off;
ods exclude all;*/  
ods output ParameterEstimates = sd_2_c;
proc phreg data = a_2 nosummary outest = betas_2_c;
strata case;
model failure*chosen (0) = unosr unotr ivtt ovttdist totcost vehwrkda;
weight weight;
title 'Logit Model with Weight (IVTT, OVTTDIST, TOTCOST and VEHWRKDA)';
run;
ods output close;
/*ods exclude none;*/

data sd_2_c;
set sd_2_c (keep = parameter estimate stderr);
t_value = estimate / stderr;
run;

proc print data = sd_2_c label noobs;
	label parameter = 'Variable' estimate = 'Coefficient (Beta)' t_value = 't stat';
	title 'Significance of Each Coefficient';
run;

title;

/*-------------------------------------------------------------Question 2 d-------------------------------------------------------------*/

/*Logit(C) with weight variable using 'phreg' (IVTT, OVTTDIST, TOTCOST, VEHWRKDA, POPSR and POPTR)*/
/*Record and calculate the t statistic ('Significance Test for Each Coefficient') of each coefficient via 'ODS' and 'DATA'*/

/*ods graphics off;
ods exclude all;*/  
ods output ParameterEstimates = sd_2_d;
proc phreg data = a_2 nosummary outest = betas_2_d;
strata case;
model failure*chosen (0) = unosr unotr ivtt ovttdist totcost vehwrkda popsr poptr;
weight weight;
title 'Logit Model with Weight (IVTT, OVTTDIST, TOTCOST, VEHWRKDA, POPSR and POPTR)';
run;
ods output close;
/*ods exclude none;*/

data sd_2_d;
set sd_2_d (keep = parameter estimate stderr);
t_value = estimate / stderr;
run;

proc print data = sd_2_d label noobs;
	label parameter = 'Variable' estimate = 'Coefficient (Beta)' t_value = 't stat';
	title 'Significance of Each Coefficient';
run;

title;

/*-------------------------------------------------------------Question 2 e-------------------------------------------------------------*/

/*Logit(C) with weight variable using 'phreg' (IVTT, OVTTDIST, TOTCOST, VEHWRKDA, POPTR, MALESR, MALETR, AGESR and AGETR)*/
/*Record and calculate the t statistic ('Significance Test for Each Coefficient') of each coefficient via 'ODS' and 'DATA'*/

/*ods graphics off;
ods exclude all;*/  
ods output ParameterEstimates = sd_2_e;
proc phreg data = a_2 nosummary outest = betas_2_e;
strata case;
model failure*chosen (0) = unosr unotr ivtt ovttdist totcost vehwrkda poptr MALESR MALETR AGESR AGETR;
weight weight;
title 'Logit Model with Weight (IVTT, OVTTDIST, TOTCOST, VEHWRKDA, POPTR, MALESR, MALETR, AGESR and AGETR)';
run;
ods output close;
/*ods exclude none;*/

data sd_2_e;
set sd_2_e (keep = parameter estimate stderr);
t_value = estimate / stderr;
run;

proc print data = sd_2_e label noobs;
	label parameter = 'Variable' estimate = 'Coefficient (Beta)' t_value = 't stat';
	title 'Significance of Each Coefficient';
run;

title;

/*-------------------------------------------------------------Question 2 f-------------------------------------------------------------*/

/*Logit(C) with weight variable using 'phreg' (IVTT, OVTTDIST, TOTCOST, VEHWRKDA, POPTR and HIGHINC)*/
/*Record and calculate the t statistic ('Significance Test for Each Coefficient') of each coefficient via 'ODS' and 'DATA'*/
/*ods graphics off;
ods exclude all;*/
ods output ParameterEstimates = sd_2_f;
proc phreg data = a_2 nosummary outest = betas_2_f;
strata case;
model failure*chosen (0) = unosr unotr ivtt ovttdist totcost totcost*HIGHINC vehwrkda poptr;
weight weight;
title 'Logit Model with Weight (IVTT, OVTTDIST, TOTCOST, VEHWRKDA, POPTR and HIGHINC)';
run;
ods output close;
/*ods exclude none;*/

data sd_2_f;
set sd_2_f (keep = parameter estimate stderr);
t_value = estimate / stderr;
run;

proc print data = sd_2_f label noobs;
	label parameter = 'Variable' estimate = 'Coefficient (Beta)' t_value = 't stat';
	title 'Significance of Each Coefficient';
run;


/*Calculate the 'Value of In-Vehicle Travel Time ($/hr)' for each income group and print it*/
proc sql;
create table Q_2_f as select ivtt/totcost*60 as v_of_ivtt_lowInc, ivtt/(totcost+totcostHIGHINC)*60 as v_of_ivtt_highInc from betas_2_f;
quit;

proc print data = q_2_f label noobs;
	label v_of_ivtt_lowInc = 'Value of In-Vehicle Travel Time of Low-income Group($/hr)' v_of_ivtt_highInc = 'Value of In-Vehicle Travel Time of High-income Group($/hr)';
	title 'Value of In-Vehicle Travel Time ($/hr)';
run;

title;

/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------Question 3--------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------Question 3 a-------------------------------------------------------------*/

/*Using model with vars. IVTT, OVTT and TOTCOST (Constants UNOSR and UNOTR)*/

ods output ParameterEstimates = sd_3_a;
proc phreg data = a_2 nosummary outest = betas_3_a;
strata case;
model failure*chosen (0) = unosr unotr ivtt ovtt totcost;
weight weight;
title 'Logit Model with Weight (IVTT, OVTT and TOTCOST)';
run;
ods output close;

data sd_3_a;
set sd_3_a (keep = parameter estimate stderr);
t_value = estimate / stderr;
run;

proc print data = sd_3_a label noobs;
	label parameter = 'Variable' estimate = 'Coefficient (Beta)' t_value = 't stat';
	title 'Significance of Each Coefficient';
run;

/*The following stpes calculate the probabilities of each alternatives within each case*/
/*1. using the betas_0 and the corresponding vars(unosr and unotr) to calculate the utilities*/
proc sql;
create table q_3_a as select alt as alt, mean(ivtt) as ivtt, mean(ovtt) as ovtt, mean(totcost) as totcost from a_2 group by alt;
quit;

data q_3_a;
set q_3_a;
if alt = 1 then unosr = 0;
else if alt = 2 then unosr = 1;
else unosr = 0;
run;

data q_3_a;
set q_3_a;
if alt = 1 then unotr = 0;
else if alt = 2 then unotr = 0;
else unotr = 1;
run;

proc score data = q_3_a score = betas_3_a type = parms out = p_3_b;
	var unosr unotr ivtt ovtt totcost;
run;

data p_3_b (rename = (failure = ut));
set p_3_b;
run;

/*2. exponentiate each utility*/
data p_3_b;
set p_3_b;
label ut = 'utility';
p = exp(ut);
run;

/*3. sum up the total utility for each case*/
proc means data = p_3_b noprint;
	output out = s_3_b sum(p) = sp;
run;

/*4. merge two data set and calculate the probability of each alternative*/
data p_3_b;
	merge p_3_b s_3_b(keep = sp);
run;

data p_3_b;
set p_3_b;
if sp ^=. then k = sp;
	retain k;
sp = k;
p = p / sp;
drop k sp;
run;

/*5. Create a table to show the average choice probability of each mode and print it*/
proc print data = p_3_B label noobs;
	label alt = 'Mode' p = 'Choice Probability of Each Mode Under Average LOS Conditions';
	format alt alts. p percent10.2;
	title 'Choice Probability of Each Mode Under Average LOS Conditions';
run;

title;
