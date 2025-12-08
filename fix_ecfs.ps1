$ecfFiles = Get-ChildItem -Path "D:\prod\simple_*\*.ecf" -File

foreach ($ecf in $ecfFiles) {
    $content = Get-Content $ecf.FullName -Raw

    # Check if this ECF has a test target with simple_testing but missing testing.ecf
    if ($content -match "_tests" -and
        $content -match "simple_testing" -and
        $content -notmatch 'location="\$ISE_LIBRARY\\library\\testing\\testing\.ecf"') {

        # Add testing.ecf after simple_testing line
        $newContent = $content -replace '(<library name="simple_testing" location="\$SIMPLE_TESTING\\simple_testing\.ecf"/>)',
            '$1
		<library name="testing" location="$ISE_LIBRARY\library\testing\testing.ecf"/>'

        Set-Content -Path $ecf.FullName -Value $newContent -NoNewline
        Write-Host "Fixed: $($ecf.Name)"
    }
}

Write-Host "`nDone fixing ECF files"
