# Configuración inicial
$global:Config = @{
    Guide = @{
        Name = "Kitty"
        Mood = "happy"
    }
    Paths = @{
        History = "history.json"
        References = "references.txt"
        Downloads = "downloads"
    }
}

# Importar módulos
. .\gui.ps1
. .\download.ps1
. .\utils.ps1

# Inicializar directorios
Initialize-Directories

# Mostrar interfaz inicial
Show-WelcomeScreen

function Get-APAFromHistory {
    $history = Get-History
    
    if ($history.Count -eq 0) {
        Show-Error "No hay descargas registradas en el historial."
        return
    }
    
    Show-History
    $choice = Read-Host "`nSelecciona el número del video para generar la referencia APA (o 'q' para volver)"
    
    if ($choice -eq 'q') {
        return
    }
    
    if (Validate-Choice $choice $history.Count) {
        $entry = $history[$choice - 1]
        $reference = Get-APAReference $entry
        Save-Reference $reference
        Write-Host "`nReferencia APA guardada y ordenada en references.txt" -ForegroundColor Green
        Write-Host "`nPresiona cualquier tecla para continuar..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    else {
        Show-Error "Opción no válida. Por favor selecciona un número de la lista."
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
