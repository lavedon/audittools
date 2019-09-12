# Basic Template Not Yet Done
Remove-Variable html

# Import Client Information
# The Name is on the first line
# The client logo is on the second
$clientInfo = Get-Content .\client.txt

# Graphics to convert to bits
$imageClient = $clientInfo[1];
$imageGmail = "c:\inbox\htmlreports\audit\gmail.png";
$imageOutlook = "c:\inbox\htmlreports\audit\outlook.png";


# @TODO use an array 
$clientBits = [Convert]::ToBase64String((Get-Content $imageClient -Encoding Byte))
$gmailBits = [Convert]::ToBase64String((Get-Content $imageGmail -Encoding Byte))
$outlookBits = [Convert]::ToBase64String((Get-Content $imageOutlook -Encoding Byte))

$clientImageHTML = "<img src=data:image/png;base64,$($clientBits) alt='db utilization' width='150' height='150'/>";
$gmailImageHTML = "<img src=data:image/png;base64,$($gmailBits) alt='db utilization' width='150' height='150'/>";    
$outlookImageHTML = "<img src=data:image/png;base64,$($outlookBits) alt='db utilization' width='150' height='150'/>";    

# Get data from domains
# @TODO Put This into an array
[xml]$basicDNS = $domains | foreach-object { resolve-dnsname $_ } | ConvertTo-HTML -fragment
# @TODO other dns-lookups
# A records
[xml]$ARecords = $domains | foreach-object { Resolve-DnsName -name $_ -type A } | ConvertTo-Html -fragment 
# MX Records
[xml]$MXRecords = $domains | foreach-object { Resolve-DnsName -name $_ -type MX } | ConvertTo-Html -fragment 
# CNAME Records
[xml]$CNAMERecords = $domains | foreach-object { Resolve-DnsName -name $_ -type CNAME } | ConvertTo-Html -fragment
# TXT Records
[xml]$TXTRecords = $domains | foreach-object { Resolve-DnsName -name $_ -type TXT } | ConvertTo-Html -fragment

$head = @"
<!DOCTYPE html>
<html lang="en">
<meta charset="utf-8"/>
<style>
body { 
    background-color: #FFF;
    font-family: Tahoma;
    font-size: 12pt;
}
td, th { 
    border: 1px solid black;
    border-collapse: collapse;
}
th {
    color: white;
    background-color: black;
table, tr, td, th { 
    padding: 2px; margin: 0px; 
}
tr:nth-child(odd) {
    background-color: lightgray;
}
table {
    margin-left: 50px;
}

.danger {
    background-color: red;
}

.warn {
    background-color: yellow;
}
</style>
"@


$body = @"
<a href="https://github.com/lavedon/audittools">Made with Luke's Audit Tools</a>
<br>Report for $($clientInfo[0]) &nbsp;&nbsp;&nbsp;$clientImageHTML<br /><i>$(Get-Date)</i>
$($basicDNS.InnerXml)
<br />
<h4>A Records</h4>
$($ARecords.InnerXml)
<br />
<h4>MX Records</h4>
$($MXRecords.InnerXml)
<br />
<h4>CNAME Records</h4>
$($CNAMERecords.InnerXml)
<br />
<h4>TXT Records</h4>
$($TXTRecords.InnerXml)
<br />
$gmailImageHTML
<br />
$outlookImageHTML
"@

$domains = Get-Content .\domains.txt
 

ConvertTo-HTML -head $head -body $body |
Out-file ".\report.html" -Encoding ascii;

Invoke-Item ".\report.html";