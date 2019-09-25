[array]$emails = @();
[array]$domains = @();
[array]$NSRecords = @();

$csv = import-csv email_test.csv;
foreach($item in $csv) {
    $emails += $item | Select-Object -Property email;
}

foreach($item in $emails) {
     $curDomain = $null;
     $curDomain = $item.Email.split("@")[1];
     if ($curDomain) {$domains += $curDomain};
}

Write-Host "Checking NS Records";

foreach($domain in $domains) {
    
    $result = $null;
    $result = Resolve-DnsName -name $domain -type NS
    Write-Host $result;
    
}

Write-Host "Current domains are $domains";

# Example of making an array of NS Records
[array]$currNSRecord = Resolve-DnsName -name gngrninja.com -type NS;
$currNSRecord = $currNSRecord | ForEach-Object { $_.Name };
$currNSRecord | % { if($_ -match "square") {write-host "squarespace"}};