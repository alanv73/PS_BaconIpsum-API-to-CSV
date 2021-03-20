using module .\Bacon.psm1

$API_URL = "https://baconipsum.com/api"

function getBacon($url) {
    try {
        $response = Invoke-RestMethod $url -Method Get
        return $response
    } catch {
        Write-Host "`n`tGet-Paragraph Error: $_"
    }
}

function getBaconParagraph($count) {
    $url = "$API_URL/?type=all-meat&paras=$count&format=json"

    return getBacon($url)
}

function getBaconSentence($count) {
    $url = "$API_URL/?type=all-meat&sentences=$count&format=json"

    return getBacon($url)
}

function makeBacon($count) {
    $rashers = @()

    $i = 0
    $options = [System.StringSplitOptions]::RemoveEmptyEntries
    $sentences = (getBaconSentence($count)).Split(".", $options).Trim()
    $paragraphs = getBaconParagraph($count)

    for ($i = 0; $i -lt $count; $i++) {
        $rashers += New-Object Bacon($i, $sentences[$i], $paragraphs[$i])
    }

    $rashers | Out-GridView -Title "Bacon Ipsum" -Wait
    Write-Host "`n`t$($rashers.count) Rashers downloaded from API"

    return $rashers
}

function saveBacon($bacon) {
    if ($null -ne $bacon) {
        $bacon | Export-CSV -Path "bacon.csv" -NoTypeInformation
        Write-Host "`n`t$($bacon.count) Rashers saved to bacon.csv"
    } else {
        Write-Host "`n`tNo Data to Save"
    }
}

function Menu() {
    Clear-Host
    Write-Host "`n`t===={ Menu }===="    
    Write-Host "`n`t[1] Get Bacon"
    Write-Host "`t[2] Save Bacon to CSV"
    Write-Host "`n`t[Q] Quit"

    switch (Read-Host "`n`tPlease Choose") {
        1 { $rashers = makeBacon(100) }
        2 { saveBacon($rashers) }
        "Q" { exit }
        default { Write-Host "`n`tError: Invalid choice" }
    }

    Write-Host -NoNewLine "`n`tPress any key to continue...";
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    Menu
}

Menu
