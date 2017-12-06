proc import out = work.a_4_2 datafile = 'D:\Google Drive\INES 8090\Assignment\Assignment4 dataset.csv' dbms = csv;
run;

proc logistic data = a_4_2 descending;
model whcstops = distance driver pax transit 
	  walkbike workend wendbef3 wend3to4 wend4to5 wend5to6 
	  wendaft6 highflex medflex lowflex age gender nchild ncnotstu 
	  ncstu speron sparent couple nuclear other / link = normit;
run;
/*w/o walkbike wendaft6 lowflex ncstu other
proc logistic data = a_4_2;
model whcstops = distance driver pax transit
	  workend wendbef3 wend3to4 wend4to5 wend5to6 
	  highflex medflex age gender nchild ncnotstu 
	  speron sparent couple nuclear;
run;*/

/*Drop age, since its t-stat indicates that it is not significant*/
proc logistic data = a_4_2 descending;
model whcstops = distance driver pax transit walkbike 
	  workend wendbef3 wend3to4 wend4to5 wend5to6 wendaft6
	  highflex medflex lowflex gender nchild ncnotstu ncstu
	  speron sparent couple nuclear other / link = normit;
run;

/*w/o transit base*/
proc logistic data = a_4_2 descending;
model whcstops = distance driver pax walkbike 
	  workend wendbef3 wend3to4 wend4to5 wend5to6 wendaft6
	  highflex medflex lowflex gender nchild ncnotstu ncstu
	  speron sparent couple nuclear other / link = normit;
run;

/*transit as base*/
proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend wendbef3 wend3to4 wend4to5 wend5to6 wendaft6
	  highflex medflex lowflex gender nchild ncnotstu ncstu
	  speron sparent couple nuclear other / link = normit;
run;

/*w/o wendaft6 base*/
proc logistic data = a_4_2 descending;
model whcstops = distance transit workend
	  wendbef3 wend4to5 wend5to6 wendaft6
	  highflex medflex lowflex gender nchild ncnotstu ncstu
	  speron sparent couple nuclear other/ link = normit;
run;

/*wendaft6 as base*/
proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend wend3to4  highflex medflex lowflex
	  gender nchild ncnotstu ncstu
	  speron sparent couple nuclear other/ link = normit;
run;

/*w/o medflex base*/
proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend highflex lowflex 
	  gender nchild ncnotstu ncstu
	  speron sparent couple nuclear other / link = normit;
run;

/*medflex as base*/
proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend medflex 
	  gender nchild ncnotstu ncstu
	  speron sparent couple nuclear other / link = normit;
run;

/*w/oncstu base*/
proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend medflex 
	  gender nchild  
	  speron sparent couple nuclear other/ link = normit;
run;

/*ncstu as base*/
proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend medflex 
	  gender ncnotstu ncstu 
	  speron sparent couple nuclear other / link = normit;
run;

/*w/o other base*/
proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend medflex 
	  gender speron sparent couple nuclear/ link = normit;
run;

/*other as base*/
proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend medflex 
	  gender other/ link = normit;
run;

proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend medflex 
	  gender sparent couple/ link = normit;
run;


proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend wend3to4  
	  medflex age gender 
	  sparent couple / link = normit;
run;

proc logistic data = a_4_2 descending;
model whcstops = distance transit 
	  workend  
	  medflex gender 
	  sparent couple / link = normit;
run;
