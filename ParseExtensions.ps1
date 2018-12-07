#relies on IE having been launched at least once. See the below exception.
#remove the comment on line 11 if you want to recurse your extensions and lookup all of them
#right now this is set to lookup HTTPS Everywhere from IETF
#code courtesy of https://github.com/PsychoData
<#
Invoke-WebRequest : The response content cannot be parsed because the Internet Explorer engine is not available, or Internet Explorer's first-launch configuration is not complete. Specify the UseBasicParsing parameter and try
again.
#>

$ids = 'gcbommkclmclpchllfjekcdonpmejbdp'
#$ids = Gci "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default\Extensions' | where {$_.Name -ne 'Temp'} | select -ExpandProperty Name 
$ids | ForEach-Object { 
    try {
        $resp = Invoke-WebRequest -Uri "https://chrome.google.com/webstore/detail/$_"  -ErrorAction SilentlyContinue
    }
    catch { Write-Error "Unable to fetch Chrome Web Store for ID: $_"}    
    $ChromeStoreExtenionName = $resp.ParsedHtml.nameProp -replace ' - Chrome Web Store', ''
    $object = New-Object PSObject
    if ($resp.StatusCode -eq 200) {
        $object | add-Member NoteProperty 'Name' $ChromeStoreExtenionName
    }
    else {
        $object | add-Member NoteProperty 'Name' 'Error'
    }
    $object | Add-Member NoteProperty 'ID' $_
    $object 
    Remove-Variable 'resp' -errorAction SilentlyContinue
    Start-Sleep -Milliseconds 500
} | Tee-Object -variable 'results' 
