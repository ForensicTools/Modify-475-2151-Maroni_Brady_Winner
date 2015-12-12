.\Modify.ps1

This is a powershell script to allow the user to select a given timeframe (in dates) and directory (Default is C:\ drive) to be
able to look for certain information in a file. The script will look for the last write time, last access time, creation time, length, owner, and access permissions of each file. The script will then output this information into a csv or text file if the user so chooses or can also choose to display the information into just the console window. 

The script will warn the user if they are not a local administrator and will ask them if they want to continue with the script, warning them that there will be permission errors in some cases. The user then has the option to quit the program before running it.

Usage: .\Modify.ps1 [--startdate==] [--enddate==] [--searchtype==] [--dirpath==] [--outfile==]

The user can choose any search type as stated below, but will output all the information stated above, the only difference is that the file output will show files that match specific dates for specific categories. An example would be if the user ran the script with: 

'.\Modify.ps1 --searchtype==2 --startdate==12/4/2015' 

This would have the script write output for all files that were accessed between 12/4/2015 at 00:00:00 to present date, and look at no other attrtibutes matching within this timeframe. 

The start date must come before the end date, but currently the script cannot accept specific times and only dates. 

The outfile is where the user can choose where to save the output file, even in a different directory from the script. If the user types in "--outfile==none" then the console will show the output of the file only. 

The directory path must be a valid path or the script will not run.

There is no specific order to type in options. Any of these shown below will run:
.\Modify.ps1 --searchtype==2 --startdate==12/4/2015
.\Modify.ps1 --dirpath==C:\Users --enddate==12/19/2015 --startdate==1/12/2015 --searchtype==7
.\Modify.ps1 --outfile==C:\Users\Student\Documents\OutputModify.txt --dirpath==C:\Users\Student\Downloads

There is a help option with the code and will display if the user.
The command is:
.\Modify.ps1 --help

The output of this command is shown below:
HELP PAGE--------------------------------------
Usage: .\Modify.ps1 [--startdate==] [--enddate==] [--searchtype==] [--dirpath==] [--outfile==]
Default Settings: 
Search Start date: 10 days prior to present day
Search End Date: present day/time
Search Type: Default is 1
Directory Path: C:/
Output File: modify.cvs
Note: Options may be added in any order
Note on Dates: Specify in the MM/DD/YYYY format or MM/YYYY

Search Types:
  0 = Search for files with any attributes within the specified time ranges
  1 = Search for MODIFY times ONLY
  2 = Search for ACCESS times ONLY
  3 = Search for CREATION time ONLY
  4 = Search for MODIFY *AND* ACCESS times within specified range
  5 = Search for MODIFY *AND* CREATION times within specified ranges
  6 = Search for ACCESS *AND* CREATION times within specified ranges
  7 = Search for files with MODIFY, ACCESS, and CREATION times ALL within specified ranges
  
Directory Path: Using a full path to a DIRECTORY Required
Example: C:\Users
Note: No quotes needed

Output File:
Specify file name with whatever extension you desire
Specify 'none' and the script will output to console
Note: Script creates CSV file by default

