1.	Identify prescription opioids from the drugs dataset. Refer to the truncated list of ATC codes for opioids here: N02AA01, N02AA03, N02AA05. Within the same statement, create a subsetted data that only contains the above prescription opioids. Finally, take only the first 100,000 IDs (10% sample from the population) to speed up the program execution process.

libname mod3 "/home/u57826685/myfolders";
proc contents data = mod3.drug_subset_150k;

proc print data = mod3.drug_subset_150k (obs = 20);
var atc;

data opiod (obs=100000) ;
set mod3.drug_subset_150k;
if atc = 'N02AA01' or atc ='N02AA03' or atc = 'N02AA05';

proc contents data = opiod;

2.	Create a new variable called ‘stopdate’ to denote the date on which the prescription ended.

proc sort data = opiod out = opiod;
by id date dur atc;
proc print data = opiod (obs=20); 
var id date dur atc;

data opiod1;
set opiod;
format date yymmdds9.;
stopdate = date + dur;
format stopdate yymmdds9.;


3.	Repeat steps 1-2 for benzodiazepines. Refer to the truncated list of ATC codes for benzodiazepines here: N05BA01, N05BA02, N05BA04, N05BA05, N05BA06, N05BA08, N05BA09, N05BA10, N05BA12. Similarly, take only the first 100,000 IDs (10% sample from the population).

libname mod3 "/home/u57826685/myfolders";
proc contents data = mod3.drug_subset_150k;

data ben (obs=100000);
set mod3.drug_subset_150k;
if atc = 'N05BA01' or atc = 'N05BA02' or atc = 'N05BA04'or 
atc = 'N05BA05' or atc = 'N05BA06' or atc = 'N05BA08'or 
atc = 'N05BA09' or atc = 'N05BA10' or atc = 'N05BA12';

proc print data = ben;
by age;

4.	In the ‘sd_table_demo’ dataset, keep only the patients whose age was 18 or above at the start of follow-up.

proc contents data = mod3.sd_table_demo;
data agefiltered;
set mod3.sd_table_demo;
if age < 18 then delete;

proc print data = agefiltered (obs = 20) ;


