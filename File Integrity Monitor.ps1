

Write-Host " What operation woudld you like to run?"
write-host "A) Collect new baseline:"
Write-Host "B) Begine monitoring files with saved baseline:"


$response = Read-Host -Prompt "Please enter 'A' or 'B'"



Function Calculate-File-Hash($filePath){

$fileHash = Get-FileHash -path $filePath -Algorithm SHA512
return $fileHash
}

Function erase-If-Already-Exists($filePath) {
#to check if the Baseline already exists
$BaselineExists = Test-path -Path "C:\Users\MIchael\Desktop\baseline.txt"
    if ($BaselineExists) {
    Remove-Item -Path "C:\Users\MIchael\Desktop\baseline.txt"
    
    }
}

Function check-for-deleted-files($fileHashDictionary){
    


 
   foreach ($key in $fileHashDictionary.Keys){
    $noItemsMissing = Test-Path -Path $key
    return $noItemsMissing


    }
    }
   
    
Function initial-file-inegrity-scan($fileHashDictionary){


    if($ScanedBefore -eq $false){

        Write-Host "checking for deleted files..."

        $initialScan = check-for-deleted-files($fileHashDictionary.keys){
        if ($initialScan){
        $ScanedBefore = $true
        $message = $true
        Write-Host "all files are present"
        }
            else{
            $ScanedBefore = $false
            $message = $false
            Write-Host "$($key) has been removed "
            }
        
        if($message){
        Write-Host "all files are present"
        
        }
        else{
        Write-Host "$($key) has been removed "
        }
        }
    }


    elseif($ScanedBefore -eq $true){
    
        $scan = check-for-deleted-files($fileHashDictionary)
    
        if ($scan -eq $false){
        $ScanedBefore = $false                
        }


    }

}




if ($response.ToUpper() -eq "A"){

#delete beseline if already exists
    erase-If-Already-Exists

#create a new bseline for files of interest and save them in in baseline.txt
 
    $files = Get-ChildItem -path "C:\Users\MIchael\Desktop\bandit-overthewire"
    
    foreach ($f in $files){
    $hash = Calculate-File-Hash $f.FullName
    
    "$($hash.Path)|$($hash.hash)" | Out-File -FilePath .\Desktop\baseline.txt -Append
    
    }

    
}

elseif($response.ToUpper() -eq "B"){
    Write-Host "User entered $($response.ToUpper())"
    #load baseline as a dictionary
    $filePathAndHashes = get-content -path "C:\Users\MIchael\Desktop\baseline.txt"

    $fileHashDictionary = @{}
    
    foreach ($f in $filePathAndHashes) {
    $fileHashDictionary.add($f.split("|")[0], $f.Split("|")[1])
    
    }

    


   #loop through the baseline dictionary and compare each pair with target files
   while ($true){ 
   
   Start-Sleep -seconds 1
   initial-file-inegrity-scan($fileHashDictionary)


   
   Write-Host "monitoring files..." 
        
   #load files as a variable containing hash and path
        $files = Get-ChildItem -path "C:\Users\MIchael\Desktop\bandit-overthewire"
    


    
        foreach ($f in $files){
        $hash = Calculate-File-Hash $f.FullName

            
            

        #check if a new document has been created
        if ($fileHashDictionary[$hash.Path] -eq $null){
        Write-Host "$($hash.Path) has been created" -ForegroundColor DarkCyan
        
        
        }
        else{


            if ($fileHashDictionary[$hash.Path] -eq $hash.Hash){
            #file has not change
        
            }
            else{
            #contents of file has beeen changed
            Write-Host "the contents of $($hash.Path) has been changed"
            }
        
        }

        foreach($key in $fileHashDictionary.keys){
        $baselineexists = Test-Path -path $key
            if(-not $baselineexists){
            write-host "$($key) has been deleted "
            }

        }



        }
        
        
        
    }
}

    
  
   
     

       
   

    




