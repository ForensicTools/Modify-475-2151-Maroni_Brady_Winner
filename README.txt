.\Modify.ps1
-Powershell script

This is a powershell script to be able to check a specific directoy (provided by the user) 
The user can specify a certain date range to look for modified files from the specified directory. 
The default directory (if no argument is given) is the C:\ Drive and the date range is from 
1/1/2015 to the current date. 

There is a help option with the code and will display if the user.
The command is:
.\Modify.ps1 --help

The user's first argument in the code should be the directory path to search 
(this will also search all subdirectories and their files as well), while the
second argument should be the date (in Windows format: mm/dd/yy) and the third
arugment should be the end date. 
