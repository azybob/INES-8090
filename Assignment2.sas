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

/*proc sql;
	create table Mode_Share as select alt label = 'Mode' format = alts., sum(chosen) as Sum
	from a_2
	group by alt
	order by alt;
	alter table Mode_share
		add m_s num label = 'Mode Share';
	select alt, Sum, m_s from Mode_Share;
*/
proc sql;
	create table s_s as
	select alt,
			sum(chosen) as Frequency
		from a_2
		group by alt
		order by alt;

proc sql;
	create table m_s as
	select alt, Frequency, Frequency/sum(Frequency) as ss format = percentn10.2
		from s_s;
quit;

proc print data = m_s label;
	label alt = 'Mode' ss = 'Mode Share';
	format alt alts.;
	title 'Mode Share from The Sample';
run;

data m_s2;
	set m_s;
	if alt = 1 then mks = 0.7655;
	else if alt = 2 then mks = 0.1131;
	else mks = 0.1214;
	format mks percentn10.2;
run;

proc sql;
	create table wm_s2 as
	select alt, frequency, ss, mks, mks/ss as weight format = 10.4
		from m_s2;
quit;