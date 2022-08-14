data Ship1;
set Ship;
t=_n_;
if t=65 or t=66 then s=1; else s=0;
if t>=81 then p=1; else p=0;
run;
quit;
proc sql;
create table Part as
select y, t from Ship1 where t<=64;
run;
quit;
proc arima data=Part;
identify var=y  nlag=20;
estimate p=1;
run;
quit;
data Future;
input y t s p;
cards;
. 101 0 1
. 102 0 1
. 103 0 1
. 104 0 1
. 105 0 1
;
run;
data Ship2; 
update Ship1 Future;
by t s p;
run;
proc arima data=Ship2;
identify var=y crosscorr=(s p) nlag=20;
estimate p=1 input=(s p) printall;
forecast lead=5 out=Result alpha=0.01;
run;
quit;

