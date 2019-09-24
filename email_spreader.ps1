$emails = @();
$domains = @();

$csv = import-csv email_test.csv;

foreach($item in $csv) {
    $domains += $item | select-object -property email
}

# Try something like this
###
# foreach($item in $csv) {
#     $domains += $item | select-object -property email | $_.Email.split("@")[1];
#}