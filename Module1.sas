***1.	Use libname statement to create a location for the four datasets.
libname mod1 "/home/u57826685/myfolders";
proc contents data = mod1.sd_table_death;

***2.	In the ‘sd_table_death’ dataset, create a variable called ‘age_end’, which denotes the age at which the follow-up ended for each patient. Use ‘year(end)’ to derive the year in which follow-up ended (Hint: Use ‘new-variable = old-variable’ form to create the new variable). Make sure that the dataset you created is in a temporary directory (i.e., Work).
data work;
set mod1.sd_table_death;
year = year(end);
age_end = year - year_of_birth;
run;

***3.	In the ‘sd_table_demo’ dataset, drop the ‘year_of_birth’ variable by using the ‘drop’ statement and listing the name of the variable you want to drop. Store this new dataset in the temporary directory (i.e., Work).
data work;
set mod1.sd_table_death;
year = year(end);
age_end = year - year_of_birth;
drop year_of_birth
run;