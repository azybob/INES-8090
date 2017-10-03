proc import datafile = '/home/yl700/Data/Assignment1.xlsx' dbms = xlsx out = c_t;
run;

/* proc print data = c_t;
title 'Commute-travel Data From Boston Metropolitan';
run;*/
proc format;
	value modes 0='Transit' 1='Car';
	value genders 0='Female' 1='Male';
	value transfers 0='No transfer' 1='1 or more transfer';
	value hhincs low-25000='Low' 25000-50000='Normal' 50000-75000='High' 75000-high='Very High';
	value ivtt_cs low-15 = 'Very Low' 15-30 = 'Low' 30-45 = 'Normal' 45-60 = 'High' 60-high = 'Very High';
	value ivtt_ts low-15 = 'Very Low' 15-30 = 'Low' 30-45 = 'Normal' 45-60 = 'High' 60-high = 'Very High';
	value cost_cs low-1 = 'Very Low' 1-2 = 'Low' 2-3 = 'Normal' 3-4 = 'High' 4-high = 'Very High';
	value modess 0 = 1 1 = 2;
run;

/*proc chart data=c_t;
	format mode modes. gender genders. transfer transfers.;
	vbar mode / type=percent midpoints = 0 1;
	title 'Sample Shares of The Two Modes';
run;*/

proc freq data=c_t;
	title 'Frequency Data';
	format mode modes. gender genders. transfer transfers.;
	table mode gender numveh nworkers nlicdriv;
run;

proc sgplot data=c_t;
	format mode modes. gender genders. transfer transfers.;
	vbar gender;
	title 'Frequency Distribution of Gender';
run;

proc sgplot data=c_t;
	vbar numveh;
	title 'Frequency Distribution of Total Number of Vehicles in The Household';
run;

proc sgplot data=c_t;
	format mode modes. gender genders. transfer transfers.;
	vbar nworkers;
	title 'Frequency Distribution of Total Number of Workers in The Household';
run;

proc sgplot data=c_t;
	vbar nlicdriv;
	title 'Frequency Distribution of Total Number of Licensed Drivers in The Household';
run;

/*proc univariate data=c_t;
	var hhinc;
	title 'Descriptive Statistic Analysis of Household Income';
run;

proc gplot data=c_t;
	symbol i=none v=star;
	plot hhinc*personid;
run;*/

proc sgplot data=c_t;
	format hhinc hhincs.;
	vbar hhinc;
	title 'Frequency Distribution of Household Income';
run;

proc sgplot data=c_t;
	title 'Frequency Distribution of Transfer Indicator';
	format mode modes. gender genders. transfer transfers.;
	vbar transfer;
run;

proc freq data=c_t;
	title 'Cross-tabulate of Mode-Gender';
	format mode modes. gender genders. transfer transfers.;
	table gender*mode;
run;

proc freq data=c_t;
	title 'Cross-tabulate of Mode-Total Number of Vehicles in The Household';
	format mode modes. gender genders. transfer transfers.;
	table numveh*mode;
run;

proc freq data=c_t;
	title 'Cross-tabulate of Mode-Total Number of Licensed Drivers in The Household';
	format mode modes. gender genders. transfer transfers.;
	table nlicdriv*mode;
run;

data c_t;
	set c_t;
	NVehPerLic=NumVeh/NLicDriv;
run;
proc freq data=c_t;
	title 'Cross-tabulate of Mode-Number of Vehicles Per Licensed Driver';
	format mode modes.;
	table nvehperlic*mode;
run;

proc freq data=c_t;
	title 'Cross-tabulate of Mode-Transfer Indicator';
	format mode modes. transfer transfers.;
	table transfer*mode;
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
run;*/
proc sort data = c_t;
	by mode;
run;
proc freq data = c_t;
	format ivtt_c ivtt_cs. cost_c cost_cs.;
	tables ivtt_c * cost_c/*/ chisq measures cmh*/;
	by mode;
run;
/*proc freq data = test;
	format ivtt_c ivtt_cs. cost_c cost_cs.;
	tables ic_lv * c_lv/ chisq measures cmh;
	by mode;
run;*/
/*data c_t2;
	set c_t;
	format mode modess.;
run;*/
data H1_Q2(keep = PID modes GENDER HHSIZE NUMVEH NWORKERS NLICDRIV HHINC IVTT OVTT COST TRANSFER DISTANCE CHOICE);
	set c_t;
	array IVT{2} ivtt_tr ivtt_c;
	array OVT{2} ovtt_tr ovtt_c;
	array CO{2} cost_tr cost_c;
	retain personid 0;
	personid +1;
	do i = 1 to 2;
		Modes = i-1;
		PID = personid - 1;
		CHOICE = (Mode = i-1);
		GENDER = Gender;
		HHSIZE = HHSize;
		NUMVEH = NumVeh;
		NWORKERS = NWorkers;
		NLICDRIV = NLicDriv;
		HHINC = HHInc;
		IVTT = IVT{i};
		OVTT = OVT{i};
		COST = CO{i};
		TRANSFER = Transfer;
		DISTANCE = Distance;
		output;
	end;
run;

data h1_q2;
	retain PID Modes Gender HHSize NumVeh NWorkers NLicDriv HHInc IVTT OVTT Cost Transfer Distance Choice;
	set h1_q2;
run;

proc print data= h1_q2(obs= 6);
run;



/*e)d*/
/*proc freq data=c_t;
	title 'Cross-tabulate of Mode-In Vehicle Travel Time of Car';
	format mode modes. transfer transfers.;
	table IVTT_C*mode;
run;

proc freq data=c_t;
	title 'Cross-tabulate of Mode-In Vehicle Travel Time of Transit';
	format mode modes. transfer transfers.;
	table IVTT_Tr*mode;
run;

proc freq data=c_t;
	title 'Cross-tabulate of Mode-Cost of Driving';
	format mode modes. transfer transfers.;
	table cost_c*mode;
run;

proc freq data=c_t;
	title 'Cross-tabulate of Mode-Cost of Transit';
	format mode modes. transfer transfers.;
	table cost_Tr*mode;
run;*/

proc mdc data = h1_q2;
	model choice = modes /
			type = clogit
			choice = (modes 0 1)
			covest = hess
			optmethod = qn;
	id pid;
run;
