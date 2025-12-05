# ...existing code...
# PowerShell script to read CSV and sample.feature, update output.feature, and display files

# Define file paths
$id1="1"
$csvPath = "$PSScriptRoot/test.csv"
$sampleFeaturePath = "$PSScriptRoot/sample.feature"
$outputFeaturePath = "$PSScriptRoot/output.feature"


# Step:  Read CSV data
Write-Host "--- Processing CSV Data ---" -ForegroundColor Cyan
$csvData = Import-Csv -Path $csvPath

Read specific id from CSV
$csvData = $csvData | Where-Object { $_.id -eq $id1 }
if (-not $csvData) {
    Write-Host "No rows found with id 3. No update performed." -ForegroundColor Yellow
    exit 0
}

# Step 4: Read the template from sample.feature
$template = Get-Content -Path $sampleFeaturePath -Raw

# Step 5: Update output.feature for the selected row(s)
Write-Host "Updating output.feature with CSV data for id=3..." -ForegroundColor Yellow
Write-Host ""

$updatedContent = $template
foreach ($row in $csvData) {
    $updatedContent = $updatedContent -replace '\$name', $row.name
    $updatedContent = $updatedContent -replace '\$password', $row.password
    $updatedContent = $updatedContent -replace '\$id', $row.id
}

# Write updated content to output.feature
Set-Content -Path $outputFeaturePath -Value $updatedContent

# Step 6: Display the updated output.feature file
Write-Host "--- Updated Output Feature File (output.feature) ---" -ForegroundColor Cyan
Write-Host ""
cat $outputFeaturePath
Write-Host ""


Write-Host "=== Feature File Update Complete ===" -ForegroundColor Green
# ...existing code...