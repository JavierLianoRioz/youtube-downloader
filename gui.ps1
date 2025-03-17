function Show-WelcomeScreen {
    Clear-Host
    Show-Guide
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  Bienvenido al Descargador de Videos  " -ForegroundColor Yellow
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " Presiona cualquier tecla para continuar..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

$global:Guide = @{
    Name = "Kitty"
    Mood = "happy"
}

function Show-Guide {
    switch ($global:Guide.Mood) {
        "happy" {
            Write-Host @"
   /\_/\  
  ( o.o ) 
   > ^ <
"@ -ForegroundColor Green
        }
        "sad" {
            Write-Host @"
   /\_/\  
  ( T.T ) 
   > ^ <
"@ -ForegroundColor Blue
        }
        "confused" {
            Write-Host @"
   /\_/\  
  ( o.O ) 
   > ^ <
"@ -ForegroundColor Yellow
        }
        "thinking" {
            Write-Host @"
   /\_/\  
  ( -.- ) 
   > ^ <
"@ -ForegroundColor Magenta
        }
        "working" {
            Write-Host @"
   /\_/\  
  ( ^.^ ) 
   > ^ <
"@ -ForegroundColor Cyan
        }
        default {
            Write-Host @"
   /\_/\  
  ( o.o ) 
   > ^ <
"@ -ForegroundColor White
        }
    }
    Write-Host "`nHola, soy $($global:Guide.Name), tu asistente felino!" -ForegroundColor Magenta
}

function Show-ProgressBar {
    param (
        [int]$percent
    )
    $barLength = 50
    $filled = [math]::Round($percent * $barLength / 100)
    $empty = $barLength - $filled
    
    Write-Host "`n[" -NoNewline
    Write-Host ("=" * $filled) -NoNewline -ForegroundColor Green
    Write-Host (" " * $empty) -NoNewline
    Write-Host "] $percent%`n" -ForegroundColor Yellow
}

function Show-History {
    Clear-Host
    Show-Guide
    Write-Host "`nHistorial de Descargas" -ForegroundColor Yellow
    Write-Host "====================" -ForegroundColor Cyan
    
    $history = Get-Content "history.json" -Raw | ConvertFrom-Json
    if ($history.Count -eq 0) {
        Write-Host "No hay descargas registradas." -ForegroundColor Red
        return
    }
    
    for ($i = 0; $i -lt $history.Count; $i++) {
        Write-Host " [$($i + 1)] $($history[$i].title)" -ForegroundColor Cyan
    }
}

function Show-MainMenu {
    Clear-Host
    Show-Guide
    Write-Host "`n¿Qué deseas hacer?" -ForegroundColor Yellow
    Write-Host " 1. Descargar video del portapapeles" -ForegroundColor Cyan
    Write-Host " 2. Ver historial de descargas" -ForegroundColor Cyan
    Write-Host " 3. Generar referencia APA" -ForegroundColor Cyan
    Write-Host " 4. Salir`n" -ForegroundColor Cyan
}
