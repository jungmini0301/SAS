libname mod "/home/u57826685/myfolders";
libname output "/home/u57826685/myfolders";


proc datasets lib=mod;
contents data=sd_table_diag order=varnum;
run;
contents data = sd_table_demo order=varnum;
run;
contents data = drug_subset_150k order=varnum;
quit;


proc sql;
   select count(distinct(id))
   from mod.sd_table_diag;
quit;

proc sql;
   select count(distinct(id))
   from mod.drug_subset_150k;
quit;

* 1. Identify conditions;

data output.t01; 
   set mod.sd_table_diag; if dx in ('691', '710', '720', '714','410', '411','412','413','414'); 
   run;
  
proc sql;
   select count(distinct(id))
   from output.t01;
quit;

* 2. Identify first diagnosis of 691;

data output.t02;
      set output.t01;
      by id;
      if first.id and dx = '691' then flag = 1;
      else if first.id and dx ne '691' then flag = 0;
      else flag = 0;
run;

proc sql;
   select count(distinct(id))
   from output.t02;
quit;

* 3. Link to sd_table_demo;

data output.t03;
merge mod.sd_table_demo (in = a keep= id male year_of_birth) output.t02 (in = b);
by id;
if b;
run;

* 9. create a diagage variable;
data output.t04;
set output.t03;
diagage = year(date) - year_of_birth;
format diagage $10.;
run;

proc sql;
   select count(distinct(id))
   from output.t04;
quit;

PROC SORT data = output.t04 nodupkey out = output.sorted;
by id;
run;

proc sql;
   select count(distinct(id))
   from output.sorted;
quit;

* 3. Create dataset with only the first ID among those with initial diagnosis of 691;

proc sql;

   create table output.t05 as
   select id, sum(flag) as initial
   from output.t02
   group by id
   having initial =1;

quit;

proc sql;
   select count(distinct(id))
   from output.t05;
quit;

* 4. Merge the above two datasets;

proc sql;

   create table output.t06 as
   select a.id, a.male, a.year_of_birth, a.dx, a.diagage, b.id
   from output.t04 as a
   left join output.t05 as b
   on a.id = b.id
   where a.id in (select b.id from output.t05 as b);

quit;

proc freq data = output.t06;
table dx; run;

* 5. comorbid0 (0/1): individuals who (don't) have psychological comorbidities;
proc sql;
   create table output.t07 as
   select id, count(distinct(dx)) as comorbid0
   from output.t06
   group by id;
quit;


data output.t08;
set output.t07;
by id;
retain comorbid1 comorbid2;
if (first.id) then
do;
comorbid1 = 0;
comorbid2 = 0;
end;
if comorbid0 >= 2 then comorbid1 = 1;
if comorbid0 =3 then comorbid2 = 1;
run;


proc sql;
   select count(distinct(id))
   from output.t08;
quit;

proc freq data = output.t08;
table comorbid1; run;

* 6. filter servere atopic dermatitis patients using drug_subset_150k;
data output.drug; 
   set mod.drug_subset_150k; if atc in ('L01BA01', 'L04AX01', 'L04AA06', 'AD05AD02','L04AD01');
   run;

proc sql;
   select count(distinct(id))
   from output.drug;
quit;

data output.drug1;
   set output.drug;
   by id;
   ad_status = 1;
   if first.id;
   
* 7. Link to drug_subset_150k;

data output.t09;
merge output.t08 (in = a) output.drug1 (in = b keep=id ad_status);
by id;
if a;
run;

data output.t10;
set output.t09;
if ad_status = . then ad_status = 0;
run;

proc freq data = output.t10;
table ad_status; run;


* 10. merge data sets;

data output.t11;
merge output.t10 (in = a ) output.sorted (in = b);
by id;
if a;
run;


* 11. filter age;
proc sql;
   create table output.t12 as
   select *
   from output.t11
   where diagage between 18 and 64;
quit;

proc sql;
   select count(distinct(id))
   from output.t12;
   
quit;
proc freq data = output.t11;
table comorbid2; run;

