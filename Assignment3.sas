/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------Data Preparation-------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*Import file under Mosaic Computer environment*/
/*proc import out = work.a_3 datafile = 'W:\Documents\HW Assignments\INES 8090\Assignment\Assignment3.csv' dbms = csv;*/
/*Import file under SAS Studio Environment*/
/*proc import datafile = '/home/yl700/Data/Assignment3.csv' dbms = csv out = work.a_3;*/
/*Import file under Citrix Remote Access environment*/
/*proc import out = work.a_3 datafile = '\\client\D$\Google Drive\INES 8090\Assignment\Assignment3.csv' dbms = csv;*/
/*Import file under My Own Computer environment*/
proc import out = work.a_3 datafile = 'D:\Google Drive\INES 8090\Assignment\Assignment3.csv' dbms = csv;
run;

/*Create two columns representing the case ID and alternatives no. respectively*/
data a_3;
set a_3;
PID = ceil(_n_/3);
if mod(_n_,3) ^= 0 then ALT = mod(_n_,3);
else ALT = 3;
run;

/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------Question 3--------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------Question 3 a-------------------------------------------------------------*/
/*Multinomial logit model estimation (MNL)*/
proc mdc data = a_3;
	model choice = unoair unorail ivtt ovtt cost freq /
			type = clogit
			choice = (alt 1 2 3)
			covest = hess
			optmethod = qn;
	id pid;
run;


/*data a_3_b_1;
set a_3;
if ALT ^= 1 then UPALT = 2;
else UPALT = 1;
run;
*/

/*--------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------Question 3--------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------Question 3 b-------------------------------------------------------------*/
/*1. Nested logit model estimation with "Common Carrier Nested (Car, Air & Rail)" (NL)*/
proc mdc data = a_3 type = nlogit;
	model choice = unoair unorail ivtt ovtt cost freq /
			choice = (alt 1 2 3)
			samescale;
	id pid;
	utility u(1,) = unoair unorail ivtt ovtt cost freq; 
	nest level(1) = (1 @ 1, 2 3 @ 2),
		 level(2) = (1 2 @ 1);
/*	test INC_L2G1C1=1, INC_L2G1C2=1/LR;*/
run;

/*2. Nested logit model estimation with "Ground Transportation Nested (Air, Car & Rail)" (NL)*/
proc mdc data = a_3 type = nlogit;
	model choice = unoair unorail ivtt ovtt cost freq /
			choice = (alt 1 2 3)
			samescale;
	id pid;
	utility u(1,) = unoair unorail ivtt ovtt cost freq;
	nest level(1) = (2 @ 1, 1 3 @ 2),
		 level(2) = (1 2 @ 1);
/*	test INC_L2G1C1=1, INC_L2G1C2=1/LR;*/
run;

/*3. Nested logit model estimation with "Air-Car Nested (Rail, Car & Air)" (NL)*/
proc mdc data = a_3 type = nlogit;
	model choice = unoair unorail ivtt ovtt cost freq /
			choice = (alt 1 2 3)
			samescale;
	id pid;
	utility u(1,) = unoair unorail ivtt ovtt cost freq;
	nest level(1) = (3 @ 1, 1 2 @ 2),
		 level(2) = (1 2 @ 1);
/*	test INC_L2G1C1=1, INC_L2G1C2=1/LR;*/
run;

