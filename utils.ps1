function Initialize-Directories {
    # Crear directorio de descargas si no existe
    if (-not (Test-Path $global:Config.Paths.Downloads)) {
        New-Item -ItemType Directory -Path $global:Config.Paths.Downloads | Out-Null
    }
}

function Get-History {
    $historyPath = $global:Config.Paths.History
    if (-not (Test-Path $historyPath)) {
        return @()
    }
    return Get-Content $historyPath -Raw | ConvertFrom-Json
}

function Save-Reference {
    param (
        [string]$reference
    )
    
    $referencesPath = $global:Config.Paths.References
    
    # Leer referencias existentes
    $references = @()
    if (Test-Path $referencesPath) {
        $references = Get-Content $referencesPath
    }
    
    # Agregar nueva referencia y ordenar
    $references += $reference
    $references = $references | Sort-Object
    
    # Guardar referencias ordenadas
    Set-Content -Path $referencesPath -Value $references
}

function Validate-Choice {
    param (
        [string]$choice,
        [int]$maxValue
    )
    
    if ($choice -match '^\d+$' -and $choice -le $maxValue -and $choice -gt 0) {
        return $true
    }
    return $false
}

function Show-Error {
    param (
        [string]$message
    )
    
    $global:Config.Guide.Mood = "confused"
    Show-Guide
    Write-Host "`n$message" -ForegroundColor Red
    Start-Sleep -Seconds 1
}
