# Modify-475-2151-Maroni_Brady_Winner-1
A powershell script to be able to check a specific directory for files matching a particular date range.

.\project.ps1
-Powershell script

This is a powershell script to be able to check a specific directoy (provided by the user). 
The user can specify a certain date to look for modified files from. 
The default directory (if no arguments from the user are given) is the C:\ Drive. 
The default date range is from 1/1/2015-Current Date. 

There is a help option with the code and will display if the user.
The command is:
.\project.ps1 --help

The user's first argument in the code should be the directory path to search (this will also 
search all subdirectories and their files as well), while the second argument should be the 
dates.
