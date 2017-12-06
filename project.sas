/*proc import out = proj.pro_or datafile = 'C:\Users\azybo\Dropbox\Courses Related\UNCC\Dr. Fan\PedCrashNC_2007-2014.xlsx' dbms = xlsx;
run;*/

libname proj 'D:\Google Drive\INES 8090\proj';

libname proj'W:\Documents\HW Assignments\INES 8090\Project\proj';

/*count the no. of varibales*/
%let dsid=%sysfunc(open(proj.pro_or,i));  
%let n=%sysfunc(attrn(&dsid,nvars));
%let rc=%sysfunc(close(&dsid));
%put obsnum=&n;

/*the basic statistics of char. var.*/
proc freq data = proj.pro_2;
tables _character_ / nocum;
run;

data proj.pro_1;
set proj.pro_or (drop = city county towrdrd onroad FrmRd);
run;

/*data proj.pro_2;
set proj.pro_1;
if pedalcdrg ^= '#NULL!' then pedaldr = pedalcdrg;
else pedaldr = pedalcohol;
run;*/

data proj.pro_2;
set proj.pro_1;
if AmbulanceR = 'Yes' then AmbulanceR = 1;
else AmbulanceR = 0;
run;

data proj.pro_2;
set proj.pro_2;
if CrashAlcoh = 'Yes' then CrashAlcoh = 1;
else CrashAlcoh = 0;
run;

data proj.pro_3;
set proj.pro_2 (drop = DrvrAlcDrg DrvrAlcoho PedAlcDrg PedAlcohol);
run;

/*count the no. of varibales*/
%let dsid=%sysfunc(open(proj.pro_3,i));  
%let n=%sysfunc(attrn(&dsid,nvars));
%let rc=%sysfunc(close(&dsid));
%put obsnum=&n;

/*data proj.pro_3;
set proj.pro_3 (drop = pedaldr);
run;*/

data proj.pro_3;
set proj.pro_3 (drop = CrashDate CrashDay CrashHour CrashYear /*CrashTime*/ CrashMonth DrvrInjury DstncMiFrm Latitude
				NumPedsAIn NumPedsBIn NumPedsCIn NumPedsKil NumPedsNoI NumPedsUIn NumTotPeds RteInvdCd);
run;

/*above processes roughly dropped most unnecessary vars*/


/*count the no. of varibales*/
%let dsid=%sysfunc(open(proj.pro_3,i));  
%let n=%sysfunc(attrn(&dsid,nvars));
%let rc=%sysfunc(close(&dsid));
%put obsnum=&n;

proc freq data = proj.pro_3;
tables _character_ / nocum;
run;

data pro1;
set proj.pro_3;
if DrvrAge = 'Unknown' then delete;
run;

data pro1;
set pro1;
if PedInjury = 'Unknown Injury' then delete;
run;

data pro1;
set pro1;
if PedAge = 'Unknown' then delete;
run;

data pro1;
set pro1;
if DrvrSex = 'Unknown' then delete;
run;

data pro1;
set pro1 (drop = NumLanes);
run;

data pro1;
set pro1 (drop = CrashSevr);
run;

data pro1;
set pro1;
if PedSex = 'Unknown' then delete;
run;

data pro1;
set pro1 (drop = PedAgeGrp);
run;

data pro1;
set pro1 (drop = Longitude);
run;

data pro1;
set pro1 (drop = objectid);
run;

data pro1;
set pro1 (drop = DrvrAgeGrp);
run;

data pro1;
set pro1;
if LightCond = 'Unknown' then delete;
else if LightCond = 'Dark - Unknown Lighting' then delete;
else if LightCond = 'Other' then delete;
run;

data pro1;
set pro1;
if RdConfig = 'Unknown' then delete;
run;

data pro1;
set pro1;
if DrvrVehTyp = 'Pedestrian' then delete;
run;

data pro2;
set pro1;
if SpeedLimit = 'Unknown' then delete;
run;

data pro2;
set pro2;
if RdCharacte = 'Unknown' then delete;
else if RdCharacte = 'Other' then delete;
run;

data pro2;
set pro2;
if DrvrEstSpd = 'Unknown' then delete;
run;

data pro2;
set pro2;
if RdConditio = 'Unknown' then delete;
else if RdConditio = 'Other' then delete;
run;

data pro2;
set pro2;
if Weather = 'Other' then delete;
run;

data pro2;
set pro2;
if DrvrVehTyp = 'Unknown' then delete;
run;

data pro2;
set pro2;
if CrashGrp = 'Other / Unknown - Insufficient Details' then delete;
run;

data pro2;
set pro2;
if CrashType = 'Assault with Vehicle' then delete;
run;

data pro2;
set pro2 (drop = RdDefects);
run;

data pro2;
set pro2 (drop = RdSurface);
run;

data pro2;
set pro2;
if TraffCntrl = 'Other' then delete;
run;

data pro2;
set pro2;
if DrvrRace = 'Unknown/Missing' then delete;
run;

data pro2;
set pro2;
if PedRace = 'Unknown/Missing' then delete;
run;

/*12/06/207 created*/
data proj.pro_1206_1;
set pro1;
run;

data proj.pro_1206_2;
set pro2;
run;

/*pro1*/
/*count the no. of vars*/
%let dsid=%sysfunc(open(pro1,i));  
%let n=%sysfunc(attrn(&dsid,nvars));
%let rc=%sysfunc(close(&dsid));
%put obsnum=&n;

/*count the no. of observations*/
%let dsid=%sysfunc(open(pro1,i));  
%let n=%sysfunc(attrn(&dsid,nobs));
%let rc=%sysfunc(close(&dsid));
%put obsnum=&n;

/*the basic statistics of char. var.*/
proc freq data = pro1;
tables _character_ / nocum;
run;

/*pro2*/
/*count the no. of vars*/
%let dsid=%sysfunc(open(pro2,i));  
%let n=%sysfunc(attrn(&dsid,nvars));
%let rc=%sysfunc(close(&dsid));
%put obsnum=&n;

/*count the no. of observations*/
%let dsid=%sysfunc(open(pro2,i));  
%let n=%sysfunc(attrn(&dsid,nobs));
%let rc=%sysfunc(close(&dsid));
%put obsnum=&n;

/*the basic statistics of char. var.*/
proc freq data = pro2;
tables _character_ / nocum;
run;
