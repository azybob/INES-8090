/*Import external data - excel file*/
/*proc import datafile = 'W:\Documents\HW Assignments\INES 8090\Assignment1.xlsx' dbms = xlsx out = c_t;*/
proc import datafile = '/home/yl700/Data/Assignment1.xlsx' dbms = xlsx out = c_t;
run;

/*Create formats of the variables, in order to show the analysis results more readablly*/
proc format;
	value modes 0 = 'Transit' 1='Car';
	value genders 0 = 'Female' 1='Male';
	value transfers 0 = 'No transfer' 1='1 or more transfer';
	value hhincs low-25000 = 'Low' 25000-50000 = 'Normal' 50000-75000 = 'High' 75000-high = 'Very High';
	value ivtt_cs low-15 = 'Very Low' 15-30 = 'Low' 30-45 = 'Normal' 45-60 = 'High' 60-high = 'Very High';
	value ivtt_ts low-15 = 'Very Low' 15-30 = 'Low' 30-45 = 'Normal' 45-60 = 'High' 60-high = 'Very High';
	value cost_cs low-1 = 'Very Low' 1-2 = 'Low' 2-3 = 'Normal' 3-4 = 'High' 4-high = 'Very High';
	value cost_ts low-1 = 'Very Low' 1-2 = 'Low' 2-3 = 'Normal' 3-4 = 'High' 4-high = 'Very High';
	value modess 0 = 1 1 = 2;
run;

/*Question 1_a & b*/
/*Creat frequency tables of mode gender numveh nworkers nlicdriv*/
proc freq data = c_t;
	title 'Frequency Data';
	format mode modes. gender genders. transfer transfers.;
	table mode gender numveh nworkers nlicdriv;
run;

/*Plot the 'Frequency Distribution of Gender'*/
/*Use format to show the result more readablly*/
/*Bellow will be the same*/
proc sgplot data = c_t;
	format mode modes. gender genders. transfer transfers.;
	vbar gender;
	title 'Frequency Distribution of Gender';
run;

/*Plot the 'Frequency Distribution of Total Number of Vehicles in The Household'*/
proc sgplot data = c_t;
	vbar numveh;
	title 'Frequency Distribution of Total Number of Vehicles in The Household';
run;

/*Plot the 'Frequency Distribution of Total Number of Workers in The Household'*/
proc sgplot data = c_t;
	format mode modes. gender genders. transfer transfers.;
	vbar nworkers;
	title 'Frequency Distribution of Total Number of Workers in The Household';
run;

/*Plot the 'Frequency Distribution of Total Number of Licensed Drivers in The Household'*/
proc sgplot data = c_t;
	vbar nlicdriv;
	title 'Frequency Distribution of Total Number of Licensed Drivers in The Household';
run;

/*Question 1_c*/
/*Plot the 'Frequency Distribution of Household Income'*/
/*Use format to group the income into different level to show the result*/
proc sgplot data = c_t;
	format hhinc hhincs.;
	vbar hhinc;
	title 'Frequency Distribution of Household Income';
run;

/*Question 1_d*/
/*Plot the 'Frequency Distribution of Transfer Indicator'*/
proc sgplot data = c_t;
	title 'Frequency Distribution of Transfer Indicator';
	format mode modes. gender genders. transfer transfers.;
	vbar transfer;
run;

/*Question 1_e*/
/*Question 1_e_a*/
/*Cross table the mode with gender*/
proc freq data = c_t;
	title 'Cross-tabulate of Mode-Gender';
	format mode modes. gender genders. transfer transfers.;
	tables gender*mode /
		plots = freqplot(twoway = stacked orient = vertical);
run;

/*Cross table the mode with total no. of vehicles in household*/
proc freq data = c_t;
	title 'Cross-tabulate of Mode-Total Number of Vehicles in The Household';
	format mode modes. gender genders. transfer transfers.;
	table numveh*mode /
		plots = freqplot(twoway = stacked orient = vertical);
run;

/*Cross table the mode with total no. of licensed drivers in household*/
proc freq data = c_t;
	title 'Cross-tabulate of Mode-Total Number of Licensed Drivers in The Household';
	format mode modes. gender genders. transfer transfers.;
	table nlicdriv*mode /
		plots = freqplot(twoway = stacked orient = vertical);
run;

/*Question 1_e_b*/
/*Create a new variable no. of vehicles per licensed driver in household with NVehPerLic = NumVeh/NLicDriv*/
/*Cross table the mode with no. of vehicles per licensed driver in household*/
data c_t;
	set c_t;
	NVehPerLic = NumVeh/NLicDriv;
run;

proc freq data = c_t;
	title 'Cross-tabulate of Mode-Number of Vehicles Per Licensed Driver';
	format mode modes.;
	table nvehperlic*mode / 
		plots = freqplot(twoway = stacked orient = vertical);
run;

/*Question 1_e_c*/
/*Cross table the mode with transfer no.*/
proc freq data = c_t;
	title 'Cross-tabulate of Mode-Transfer Indicator';
	format mode modes. transfer transfers.;
	table transfer*mode /
		plots = freqplot(twoway = stacked orient = vertical);
run;

/*data test;
	set c_t;
	if ivtt_c <=15 then ic_lv = 'very low';
	else if ivtt_c > 15 & ivtt_c <= 30 then ic_lv = 'low';
	else if ivtt_c > 30 & ivtt_c <= 45 then ic_lv = 'normal';
	else if ivtt_c > 45 & ivtt_c <= 60 then ic_lv = 'high';
	else ic_lv = 'very high';

	if cost_c <=1 then c_lv = 'very low';
	else if cost_c > 1 & cost_c <= 2.0 then c_lv = 'low';
	else if cost_c > 2.0 & cost_c <= 3.0 then c_lv = 'normal';
	else if cost_c > 3.0 & cost_c <= 4.0 then c_lv = 'high';
	else c_lv = 'very high';
run;

proc freq data = test;
	format ivtt_c ivtt_cs. cost_c cost_cs.;
	tables ic_lv * c_lv/ chisq measures cmh;
	by mode;
run;

data c_t2;
	set c_t;
	format mode modess.;
run;*/

/*Question 1_e_d_DA*/
proc sort data = c_t;
	by mode;
run;

proc freq data = c_t;
	title 'Cross-tabulate of IVTT_C with Cost_C by Mode';
	format ivtt_c ivtt_cs. cost_c cost_cs.;
	tables ivtt_c * cost_c/*/ chisq measures cmh*/ /
		plots = freqplot(twoway = stacked orient = vertical);
	by mode;
run;

/*Question 1_e_d_Tr*/
proc sort data = c_t;
	by mode;
run;

proc freq data = c_t;
	title 'Cross-tabulate of IVTT_Tr with Cost_Tr by Mode';
	format ivtt_tr ivtt_ts. cost_tr cost_ts.;
	tables ivtt_tr * cost_tr/*/ chisq measures cmh*/ /
		plots = freqplot(twoway = stacked orient = vertical);
	by mode;
run;

/*Stop using title*/
title;

/*Sort the data by default*/
proc sort data = c_t;
	by personid;
run;

/*Question 2*/
/*Create the new data structure with desired outputs by modes with corresponding attributes*/
data H1_Q2(keep = personid modes GENDER HHSIZE NUMVEH NWORKERS NLICDRIV HHINC IVTT OVTT COST TRANSFER DISTANCE DECISION);
	set c_t;
	array IVT{2} ivtt_tr ivtt_c;
	array OVT{2} ovtt_tr ovtt_c;
	array CO{2} cost_tr cost_c;
	retain personid 0 distance gender HHSIZE NUMVEH NWORKERS NLICDRIV HHINC transfer;
	do i = 1 to 2;
		Modes = i-1;
		DECISION = (Mode = i-1);
		IVTT = IVT{i};
		OVTT = OVT{i};
		COST = CO{i};
		output;
	end;
run;

/*Format & order the adjusted data structure for further analysis*/
data h1_q2;
	retain personid Modes Gender HHSize NumVeh NWorkers NLicDriv HHInc IVTT OVTT Cost Transfer Distance Decision;
	set h1_q2;
run;

/*Print the first 3 persons' information*/
proc print data= h1_q2(obs= 6);
run;

/*Question 3*/
/*Question 3_a*/
/*Constant-only model, Logit(C)*/
proc mdc data = h1_q2;
	title 'The Constant-Only Logit Model';
	model decision = modes /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
run;

/*Question 3_b*/
/*IVTT, OVTT and Cost as generic explanatory variables*/
proc mdc data = h1_q2;
		title 'The Logit Model with IVTT, OVTT and Cost';
		model decision = modes ivtt ovtt cost /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
run;

/*Stop using title*/
title;

/*Question 3_c*/
/*Create a new variable OVTT by Distance with OVTTDist = OVTT / Distance*/
/*IVTT, OVTTDist and Cost as generic explanatory variables*/
data h1_q3c;
	set h1_q2; 
	OVTTDist = OVTT / Distance;
run;

proc mdc data = h1_q3c;
	title 'The Logit Model with IVTT, OVTTDist and Cost';
	model decision = modes ivtt ovttdist cost /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
run;

/*Stop using title*/
title;

/*Question 3_d*/
/*Create a new variable Total Travel Time with TOTIME = IVTT + OVTT*/
/*TOTIME and Cost as generic explanatory variables*/
data h1_q3d;
	set h1_q3c; 
	TOTTIME = IVTT + OVTT;
run;

proc mdc data = h1_q3d;
	title 'The Logit Model with TOTTIME and Cost';
	model decision = modes tottime cost /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
run;

/*Stop using title*/
title;

/*Question 3_e*/
/*Create a new variable Transfers Indicator with TranID = Transfer if Mode = 0, else TranID = 0*/
/*TranID, TOTTIME and Cost as generic explanatory variables*/
data h1_q3e;
	set h1_q3d;
	if modes = 0 then tranid = transfer;
	else tranid = 0;
run;

proc mdc data = h1_q3e;
	title 'The Logit Model with TOTTIME, Cost and Trandfer Indicator';
	model decision = modes tottime cost tranid /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
run;

/*Stop using title*/
title;

/*Question 3_f*/
data h1_q3f;
	set h1_q3e;
	if modes = 1 then hhinc_c = hhinc;
	else hhinc_c = 0; 
	if modes = 1 then gender_c = gender;
	else gender_c = 0;
	if modes = 1 then numveh_c = numveh;
	else numveh_c = 0;
run;

proc mdc data = h1_q3f;
	title 'The Logit Model with TOTTIME, Cost, HHInc_C, Gender_C and NumVeh_C';
	model decision = modes tottime cost hhinc_c gender_c numveh_c /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
run;

/*Question 3_g*/
proc mdc data = h1_q3f;
	title 'The Logit Model with TOTTIME, Cost and NumVeh_C';
	model decision = modes tottime cost numveh_c /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
run;

/*This is the best combination of the variables for the model*/
/*proc mdc data = h1_q3f;
	model decision = modes ovttdist tottime cost numveh_c /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
run;*/

/*Question 4_a*/
proc mdc data = h1_q3f;
	title 'The Logit Model with TOTTIME, Cost and NumVeh_C';
	model decision = modes tottime cost numveh_c /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
	output out=probdata pred=p;
run;

/*Sum up all probabilities by modes*/
proc sql;
create table sum as select sum(p) as sum, modes from probdata group by modes;
quit;

/*Create table of displaying the average probability of choosing each mode*/
data sum_prob;
	retain Modes Sum;
	set sum;
	rename sum = Avg_Prob;
	sum = sum / 543 *100;
	format modes modes.;

proc print data = sum_prob;
run;

/*Question 4_b_a*/
/*Increase the IVTT_C 25%*/
data h1_q4ba;
	set h1_q3f;
	if modes = 1 then ivtt = ivtt * 1.25;
	else ivtt = ivtt;
run;

proc mdc data = h1_q4ba;
	title 'The Logit Model with TOTTIME, Cost and NumVeh_C';
	model decision = modes tottime cost numveh_c /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
	output out=probdata1 pred=p;
run;

/*Sum up all probabilities by modes*/
proc sql;
create table sum1 as select sum(p) as sum, modes from probdata1 group by modes;
quit;

/*Create table of displaying the average probability of choosing each mode*/
data sum1_prob;
	retain Modes Sum;
	set sum1;
	rename sum = Avg_Prob;
	sum = sum / 543 *100;
	format modes modes.;

proc print data = sum1_prob;
run;

/*Question 4_b_b*/
/*Increase the Cost_C 25%*/
data h1_q4bb;
	set h1_q3f;
	if modes = 1 then cost = cost * 1.25;
	else cost = cost;
run;

proc mdc data = h1_q4bb;
	title 'The Logit Model with TOTTIME, Cost and NumVeh_C';
	model decision = modes tottime cost numveh_c /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id personid;
	output out=probdata2 pred=p;
run;

/*Sum up all probabilities by modes*/
proc sql;
create table sum2 as select sum(p) as sum, modes from probdata2 group by modes;
quit;

/*Create table of displaying the average probability of choosing each mode*/
data sum2_prob;
	retain Modes Sum;
	set sum2;
	rename sum = Avg_Prob;
	sum = sum / 543 *100;
	format modes modes.;

proc print data = sum2_prob;
run;
