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
Write-Host "Current domains are $domains";
Write-Host "Checking NS Records";

foreach($domain in $domains) {
      If ((Resolve-DnsName -Name $domain -Type NS | Select-Object -ExpandProperty Name) -match 'square') {Write-Host "Squarespace"}
      
}


