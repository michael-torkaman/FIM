
#make sure to run program from current user's directory.
#provide absolute file paths 

Function Calculate-File-Hash($filePath){
    #calculates hash for file path provided by user
    $fileHash = Get-FileHash -path $filePath -Algorithm SHA512
    return $fileHash
}

Function erase-If-Already-Exists($filePath) {
    #to check if the Baseline already exists
    $BaselineExists = Test-path -Path ".\Desktop\FIM\baseline\baseline.txt"
    if ($BaselineExists) {
    Remove-Item -Path ".\Desktop\FIM\baseline\baseline.txt"
    }
}

Write-Host " What operation would you like to run?"
write-host "A) Collect new baseline:"
Write-Host "B) Begine monitoring files with saved baseline:"
Write-Host ""
$response = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host ""




if ($response.ToUpper() -eq "A"){
    #delete beseline if already exists
    erase-If-Already-Exists
    #prompt user for file path for files 
    $filepath  = Read-Host -Prompt "please provide your file for baseline: "
    #load contents of files and calculate hash
    $files = Get-ChildItem -path $filepath   

    foreach ($f in $files){
        $hash = Calculate-File-Hash $f.FullName        
        #stores code in specified directory in the form of filepath | sha512 hash
        "$($hash.Path)|$($hash.hash)" | Out-File -FilePath .\Desktop\FIM\baseline\baseline.txt -Append
    }   
}

elseif($response.ToUpper() -eq "B"){
    #load the baseline as a dictionary
    $filePathAndHashes = get-content -path ".\Desktop\FIM\baseline\baseline.txt"
    $fileHashDictionary = @{}    

    foreach ($f in $filePathAndHashes) {
    $fileHashDictionary.add($f.split("|")[0], $f.Split("|")[1])
    }

   #loop through the baseline dictionary and compare each pair with target files     
    Write-Host ""
    Write-Host "You wil be notified of any changes to designated files"
    Write-Host "Monitoring ..."
    Write-Host ""

    while ($true){ 
        $startime = Get-Date
        Start-Sleep -seconds 1
                
        #load files as a variable containing hash and path
        $files = Get-ChildItem -path $filepath    
        foreach ($f in $files){

            $hash = Calculate-File-Hash $f.FullName

            #check if a new document has been created
            if ($fileHashDictionary[$hash.Path] -eq $null){
                $message = "$($hash.Path) has been created $($startime)" 
                $message | Out-File -FilePath C:\Users\MIchael\Desktop\FIM\baseline\log.txt -Append
                Write-Host $message -ForegroundColor Green
            }        

            #file has not changed
            else{
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash){
                }

                else{
                #contents of file has beeen changed
                $message = "$($hash.Path) contents have been changed $($startime)"
                $message | Out-File -FilePath C:\Users\MIchael\Desktop\FIM\baseline\log.txt -Append
                Write-Host $message -ForegroundColor Yellow
                }

            }
        }

        #check if any of the files have been deleted
        foreach($key in $fileHashDictionary.keys){
            $baselineexists = Test-Path -path $key
            if(-not $baselineexists){
            $message = "$($key) has been deleted $($startime)" 
            $message | Out-File -FilePath C:\Users\MIchael\Desktop\FIM\baseline\log.txt -Append
            write-host $message -ForegroundColor Red
            }
        }
    }
}