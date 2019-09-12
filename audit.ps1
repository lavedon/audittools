# Basic Template Not Yet Done
# Remove-Variable html

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
"


$body = @"
$clientImageHTML
<br />
$gmailImageHTML
<br />
$outlookImageHTML
<a href="https://github.com/lavedon/audittools">Made with Luke's Audit Tools</a>
"@

$domains = Get-Content .\domains.txt 



ConvertTo-HTML -head $head -PostContent "<br>Report for $($clientInfo[0])<br /><i>$(Get-Date)</i>" -body $body |
Out-file "$env:temp\report.html" -Encoding ascii;

Invoke-Item "$env:temp\report.html";
