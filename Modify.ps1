$num = $args.Length #counts number of arguments from the user
if($num -eq 0){ #If the user provided no arguments, set the dirpath equal to C and the time to check from equal to 1/1/15
       $dirpath="c:\"
       $time="1/1/15"
       Write-Host "Executing with default values: Location: C:\, Time range: from 1/1/15 to present"
}
elseif($num -eq 1){ #If the user provided one argument, that argument is a directory to search
       if("$($args[0])" -eq "--help"){ #if the argument is --help, list some usage instructions
              Write-Host "Usage: .\project.ps1 c:\directory 1/1/15"
              Write-Host "Default values: c:\ 1/1/15"
              exit(0)
       }
       $dirpath = "$($args[0])" #set the directory to search equal to the user provided value
       $time="1/1/15" #still use default time
       $today = Get-Date
       $end = $today.ToShortDateString() #use today as end date
       Write-Host "Executing with default time range, modified since 1/1/15"
}
else{ #If the user provided more than one argument, set the first argument equal to the directory to search and the second equal to the time to check from and the third equal the time to check up until
       $time="$($args[1])"
       $dirpath = "$($args[0])"
       $end = "$($args[2])"
}
 
Write-Host $dirpath
If (!(Test-Path $dirpath -pathType container)){ #if the user provided directory does not exist, write an error and exit the script
    Write-Host "Error: Please specify valid Directory Path"
    exit
       }
function DirCheck( $dir )
{
              foreach ($item in Get-ChildItem $dir){ #recursively checks each object in the directory
                     if (Test-Path $item.FullName -PathType Container) #if the object is a folder
                     {
                           DirCheck $item.FullName #recursively check that folder as well
                           }
                     elseif (($item.lastwritetime -gt $time) -and ($item.lastwritetime -lt $end)) { #if the object is a file, and the file was last modified date is since the time we are checking
                Write-Host "File: " $item.FullName "Last Modified: " $item.lastwritetime
                     }
              }
}
DirCheck $dirpath #calls the function within the script
