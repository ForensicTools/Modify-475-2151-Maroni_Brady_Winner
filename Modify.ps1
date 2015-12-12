#Julie Brady, Morgan Maroni, Shawn Winner
#CSEC 475 Final Project
#Permissions stuff
#Finding if user is the admin
$isAdmin = (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole("Administrators")

#If user is an administrator print this
if ($isADmin -eq $true)
{
	Write-Host "`nThis user is a Local Administrator`n"
}
#If the user is not an admin, it will give this warning to the user to understand that not all files allow access
else
{
	$continue = Read-Host "`nThis user is not a local administrator, this means there may be places it cannot access. Continue? [Y/N]: "
	#Script will continue to ask for an answer until user gives valid input
	while($continue -ne 'y' -and $continue -ne 'Y' -and $continue -ne 'n' -and $continue -ne 'N')
	{
		$continue = ""
		$continue = Read-Host "Do you want to continue? [Y/N]: "
		if ($continue -eq 'y' -or $continue -eq 'Y' -or $continue -eq 'n' -or $continue -eq 'N') {break}
	}
	#Script will exit if the user does not want to continue
	if ($continue -eq 'n' -or $continue -eq 'N')
	{
		Write-Host "Script will not run"
		exit(0)
	}
}

#Default start and end 
$EndDate = Get-Date
$StartDate = $(Get-Date).AddDays(-10) #10 days ago 

#Default Output type
$OutputType = "csv" #csv or txt

#Default Search Type
$SearchType = 1 #Modified files only

#Default Directory is C:\ drive
$DirPath = "C:\"

#Default Output Type is .csv
$OutFile = "modifytool.csv"
$mode = "csv"

#checks for help command and shows help menu if used
foreach ($n in $args){
	if ($n -eq "-h" -or $n -eq "--help"){ 
		Write-Host "HELP PAGE--------------------------------------`nUsage: .\modify.ps1 [options][--startdate==] [--enddate==] [--searchtype==] [--dirpath==] [--outfile==]`nDefault Settings:`n`tSearch Start date: $StartDate`n`tSearch End Date: $EndDate`n`tSearch Type: $SearchType`n`tDirectory Path: $DirPath`n`tOutput File: $OutFile`nNote: Options may be added in any order`n`nNote on Dates: Specify in the MM/DD/YYYY format or MM/YYYY
	`nSearch Types:`n`t0 = Search for files with any attributes within the specified time ranges`n`t1 = Search for MODIFY times ONLY`n`t2 = Search for ACCESS times ONLY`n`t3 = Search for CREATION time ONLY`n`t4 = Search for MODIFY *AND* ACCESS times within specified range`n`t5 = Search for MODIFY *AND* CREATION times within specified ranges`n`t6 = Search for ACCESS *AND* CREATION times within specified ranges`n`t7 = Search for files with MODIFY, ACCESS, and CREATION times ALL within specified ranges`n`nDirectory Path: Using a full path to a DIRECTORY Required`n`tExample: C:\Users`n`tNote: No quotes needed`n
Output File: Specify file name with whatever extension you desire`n`tSpecify 'none' and the script will output to console`n`tNote: Script creates CSV file by default " ; exit(0) }
	}
	
#Reading in arguments sent from befor starting the script
foreach ($n in $args){
	
	if($n -like '*--startdate==*'){
		$StartDate = Get-Date -Date $n.Substring(13)
		}
	elseif ($n -like '*--enddate==*'){
		$EndDate = Get-Date -Date $n.Substring(11)
		}
	elseif ($n -like '*--searchtype==*'){
		$n = $n.Substring(14)
		if (($n -lt 8) -and ($n -ge 0)){$SearchType = $n} #Just Create Date Compare
		
		else {Write-Host "Error: Search Type invalid, using default of 1"}
		}
	elseif ($n -like '*--dirpath==*'){
		$DirPath = $n.Substring(11)
		}
	elseif ($n -like '*--outfile==*'){
		$OutFile = $n.Substring(11)
		$index = $OutFile.IndexOf(".csv")
		if (($index -ne -1) -and ($Outfile.Substring($index) -eq ".csv")){
			$mode="csv"
		}
		elseif($OutFile -eq "none"){
			$mode= "none"
		}
		else{
			$mode = "text"
		}
		}
}

#Informs the user of the defaults chosen
Write-Host "Search Start date: $StartDate"
Write-Host "Search End date: $EndDate"
Write-Host "Search type: $SearchType"
Write-Host "Directory Searching: $DirPath"
if($OutFile -eq "none")
{
	Write-Host "Will Write results to console"
}
else
{
	Write-Host "Will Write results to: $OutFile"
}

if (Test-Path $DirPath -pathType leaf){ #if the user provided directory does not exist, write an error and exit the script
    Write-Host "Error: Please specify valid Directory Path"
    exit(1)
}

#Writes all the information to a CSV file depending on the choice
if($mode -eq "csv"){
	if ($SearchType -eq 0){
		Get-ChildItem $DirPath -Recurse | where-object{(($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)) -or (($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate)) -or (($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate))} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | export-csv $OutFile -force
	}
	if ($SearchType -eq 1) { 
		Get-ChildItem $DirPath -Recurse | where-object{($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | export-csv $OutFile -force
		}
	elseif($SearchType -eq 2) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate)} | Sort-Object -Property lastaccesstime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | export-csv $OutFile -force
		}
	elseif($SearchType -eq 3) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate)} | Sort-Object -Property CreationTime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | export-csv $OutFile -force
		}
	elseif($SearchType -eq 4) {
		Get-ChildItem $DirPath | where-object{($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate) -and ($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | export-csv $OutFile -force
	}
	elseif($SearchType -eq 5) {
		Get-ChildItem $DirPath | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate) -and ($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | export-csv $OutFile -force
	}
	elseif($SearchType -eq 6) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate) -and ($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | export-csv $OutFile -force
	}
	elseif($SearchType -eq 7) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate) -and ($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate) -and($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | export-csv $OutFile -force
	}
}
#Writes all the Files to a text file
elseif($mode -eq "text"){
	if ($SearchType -eq 0){
		Get-ChildItem $DirPath -Recurse | where-object{(($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)) -or (($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate)) -or (($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate))} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
	}
	if ($SearchType -eq 1) { 
		Get-ChildItem $DirPath -Recurse | where-object{($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
		}
	elseif($SearchType -eq 2) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate)} | Sort-Object -Property lastaccesstime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
		}
	elseif($SearchType -eq 3) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate)} | Sort-Object -Property CreationTime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
		}
	elseif($SearchType -eq 4) {
		Get-ChildItem $DirPath | where-object{($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate) -and ($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
	}
	elseif($SearchType -eq 5) {
		Get-ChildItem $DirPath | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate) -and ($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
	}
	elseif($SearchType -eq 6) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate) -and ($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
	}
	elseif($SearchType -eq 7) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate) -and ($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate) -and($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
	}
}
#Writes results only to console
elseif($mode -eq "none"){
	if ($SearchType -eq 0){
		Get-ChildItem $DirPath -Recurse | where-object{(($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)) -or (($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate)) -or (($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate))} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | format-list
	}
	if ($SearchType -eq 1) { 
		Get-ChildItem $DirPath -Recurse | where-object{($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
		}
	elseif($SearchType -eq 2) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate)} | Sort-Object -Property lastaccesstime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
		}
	elseif($SearchType -eq 3) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate)} | Sort-Object -Property CreationTime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
		}
	elseif($SearchType -eq 4) {
		Get-ChildItem $DirPath | where-object{($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate) -and ($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
	}
	elseif($SearchType -eq 5) {
		Get-ChildItem $DirPath | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate) -and ($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
	}
	elseif($SearchType -eq 6) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate) -and ($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
	}
	elseif($SearchType -eq 7) {
		Get-ChildItem $DirPath -Recurse | where-object{($_.CreationTime -gt $StartDate) -and ($_.CreationTime -lt $EndDate) -and ($_.LastAccessTime -gt $StartDate) -and ($_.LastAccessTime -lt $EndDate) -and($_.LastWriteTime -gt $StartDate) -and ($_.LastWriteTime -lt $EndDate)} | Sort-Object -Property lastwritetime -Descending | select-object FullName, LastWriteTime, LastAccessTime, CreationTime, Length, @{N='Owner';E={$_.GetAccessControl().Owner}}, @{N='Access';E={$_.GetAccessControl().Accesstostring}} | out-file -filepath $OutFile -force
	}

}

#Informs user that the script has finished
Write-Host "Script has finished"
