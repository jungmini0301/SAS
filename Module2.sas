libname mod2 "/home/u57826685/myfolders";

***1.	Use proc contents to display details of the ‘sd_table_death’ dataset

proc contents data = mod2.sd_table_death;

***2.	Use the order=varnum option to display details of the dataset in creation order (i.e. left to right).
proc contents data = mod2.sd_table_death order = varnum;

***3.	Tabulate the frequency of males using the ‘sd_table_demo’ dataset

libname mod2 "/home/u57826685/myfolders";
proc freq data = mod2.sd_table_demo; 
   tables male;
   
***4.	Use proc print to see the first 20 observations of just the ID and DX in the ‘sd_table_diag’ dataset.

libname mod2 "/home/u57826685/myfolders";
proc print data = mod2.sd_table_diag (obs=20);
   var id dx;
   
*** 5.	Use proc sort to organize ‘sd_table_drug’ dataset by ID and then by date. Include the ‘out=’ option to create a new dataset to be stored in the temporary library.

proc sort data = mod2.sd_table_diag out = diag;
by id date;
proc print data = diag (obs=20); 
var id date;


  
