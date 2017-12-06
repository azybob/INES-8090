/*proc import out = proj.pro_or datafile = 'C:\Users\azybo\Dropbox\Courses Related\UNCC\Dr. Fan\PedCrashNC_2007-2014.xlsx' dbms = xlsx;
run;*/

libname proj 'D:\Google Drive\INES 8090\proj';

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

data proj.pro_2;
set proj.pro_1;
if pedalcdrg ^= '#NULL!' then pedaldr = pedalcdrg;
else pedaldr = pedalcohol;
run;



