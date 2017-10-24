/*Import file under Mosaic Computer environment*/
/*proc import out = work.a_2 datafile = 'W:\Documents\HW Assignments\INES 8090\Assignment1.xlsx' dbms = xlsx;*/
/*Import file under SAS Studio Environment*/
/*proc import datafile = '/home/yl700/Data/Assignment1.xlsx' dbms = xlsx out = work.a_2;*/
/*Import file under Citrix Remote Access environment*/
proc import out = work.a_2 datafile = '\\client\D$\Google Drive\INES 8090\Assignment\Assignment2.xlsx' dbms = xlsx;    
run;

/*Create formats of the variables, in order to show the analysis results more readibly*/
proc format;
	value alts 1 = 'Drive-alone' 2 = 'Shared Ride' 3 = 'Transit';
run;

/*Compute the mode shares for each mode*/
proc sql;
	format alt alts.;
	create table summary as select alt, sum(chosen)
	from a_2
	group by alt
	order by alt;
run;
