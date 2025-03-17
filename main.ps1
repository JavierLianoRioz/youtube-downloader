# Configuración inicial
$global:Guide = @{
    Name = "Yuki"
    Mood = "happy"
}

# Importar módulos
. .\gui.ps1
. .\download.ps1

# Mostrar interfaz inicial
Show-WelcomeScreen

function Get-APAFromHistory {
    $historyPath = "history.json"
    $referencesPath = "references.txt"
    
    # Verificar si existe el historial
    if (-not (Test-Path $historyPath)) {
        $global:Guide.Mood = "confused"
        Show-Guide
        Write-Host "`nNo hay historial de descargas disponible." -ForegroundColor Red
        Start-Sleep -Seconds 1
        return
    }
    
    $history = Get-Content $historyPath -Raw | ConvertFrom-Json
    if ($history.Count -eq 0) {
        $global:Guide.Mood = "confused"
        Show-Guide
        Write-Host "`nNo hay descargas registradas en el historial." -ForegroundColor Red
        Start-Sleep -Seconds 1
        return
    }
    
    Show-History
    $choice = Read-Host "`nSelecciona el número del video para generar la referencia APA (o 'q' para volver)"
    
    if ($choice -eq 'q') {
        return
    }
    
    if ($choice -match '^\d+$' -and $choice -le $history.Count -and $choice -gt 0) {
        $entry = $history[$choice - 1]
        $reference = Get-APAReference $entry
        
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
        Write-Host "`nReferencia APA guardada y ordenada en references.txt" -ForegroundColor Green
        Write-Host "`nPresiona cualquier tecla para continuar..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    else {
        $global:Guide.Mood = "confused"
        Show-Guide
        Write-Host "`nOpción no válida. Por favor selecciona un número de la lista." -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}

function Start-MainProcess {
    do {
        Show-MainMenu
        $choice = Read-Host "`nSelecciona una opción"
        
        switch ($choice) {
            "1" {
                Initialize-Download
                Write-Host "`nPresiona cualquier tecla para continuar..." -ForegroundColor Gray
                $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
            "2" {
                $global:Guide.Mood = "thinking"
                Show-History
                Write-Host "`nPresiona cualquier tecla para continuar..." -ForegroundColor Gray
                $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
            "3" {
                $global:Guide.Mood = "thinking"
                Get-APAFromHistory
            }
            "4" {
                $global:Guide.Mood = "happy"
                Show-Guide
                Write-Host "`n¡Gracias por usar el Descargador de Videos!" -ForegroundColor Yellow
                Write-Host "Hasta pronto, $($global:Guide.Name) te espera de nuevo." -ForegroundColor Magenta
                Start-Sleep -Seconds 2
                return
            }
            default {
                $global:Guide.Mood = "confused"
                Show-Guide
                Write-Host "`nOpción no válida. Por favor selecciona una opción del menú." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    } while ($true)
}

# Crear directorio de descargas si no existe
if (-not (Test-Path "downloads")) {
    New-Item -ItemType Directory -Path "downloads" | Out-Null
}

# Iniciar proceso principal
Start-MainProcess
