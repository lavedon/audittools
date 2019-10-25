[psobject]$csv = Import-Csv -Path .\warmup.csv
$csv | foreach-object { 
    if ((resolve-dnsname -name $_.website -type MX | select-object -expandproperty name) -match 'google') { 
        write-host {"true"};
        $_ | Add-Member -MemberType NoteProperty -Name 'Google' -Value 'Yes'
        }
    else {
        write-host {"Not Google"};
        $_ | Add-Member -MemberType NoteProperty -Name 'Google' -Value 'No'
    }
}
$csv | Export-Csv -Path .\checked.csv 