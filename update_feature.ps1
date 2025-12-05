# ...existing code...
param(
    [string]$Id
)

# PowerShell script to read CSV and sample.feature, update output.feature, and display files

# Define file paths and selection (default can be overridden with -Id)
$id1 = "3"                      # default: set to "all" or a specific id like "3"
if ($Id) { $id1 = $Id }

$csvPath = "$PSScriptRoot/test.csv"
$sampleFeaturePath = "$PSScriptRoot/sample.feature"
$outputFeaturePath = "$PSScriptRoot/output.feature"

Write-Host "=== Starting Feature File Update ===" -ForegroundColor Green
Write-Host ""

# Step: Read CSV data
Write-Host "--- Processing CSV Data ---" -ForegroundColor Cyan
$csvData = Import-Csv -Path $csvPath

# Determine which rows to process
# If $id1 is "all" process every row, otherwise filter by the specified id
if ($id1 -eq 'all') {
    $rowsToProcess = $csvData
} else {
    # Ensure comparison as trimmed strings
    $target = $id1.ToString().Trim()
    $rowsToProcess = $csvData | Where-Object { $_.id.ToString().Trim() -eq $target }
}

if (-not $rowsToProcess) {
    Write-Host "No rows found with id '$id1'. No update performed." -ForegroundColor Yellow
    exit 0
}

# Read the template
$template = Get-Content -Path $sampleFeaturePath -Raw

# Update output.feature for each row.
# We overwrite the output file for each row so that after the loop the file contains the last record's values.
Write-Host "Updating output.feature for id='$id1'..." -ForegroundColor Yellow
Write-Host ""

foreach ($row in $rowsToProcess) {
    # Use literal Replace to avoid regex issues
    $instance = $template
    $instance = $instance.Replace('$name', $row.name)
    $instance = $instance.Replace('$password', $row.password)
    $instance = $instance.Replace('$id', $row.id)

    # Overwrite output file for this row (so final file will contain last processed row)
    Set-Content -Path $outputFeaturePath -Value $instance -Encoding UTF8

    Write-Host "Wrote feature for id=$($row.id)" -ForegroundColor DarkCyan
    cat .\output.feature
}


Write-Host "=== Feature File Update Complete ===" -ForegroundColor Green
# ...existing code...