proc import datafile = 'D:\Google Drive\INES 8090\Assignment\book4.xlsx' dbms = xlsx out = a_4_1;
run;

proc means data = a_4_1;
var mode numveh tottime cost;
run;

proc logistic data = a_4_1 descending;
model mode = numveh tottime cost;
run; 

proc logistic data = a_4_1 descending;
model mode = numveh tottime cost / link = normit;
run; 

proc qlim data = a_4_1;
model mode = numveh tottime cost / discrete(d=logit);
run;


proc probit data = a_4_1;
model mode = numveh tottime cost;
run;
