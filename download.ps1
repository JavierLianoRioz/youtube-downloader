function Get-ClipboardUrl {
    try {
        Add-Type -AssemblyName System.Windows.Forms
        $url = [Windows.Forms.Clipboard]::GetText()
        
        if ($url -match '^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$') {
            return $url
        }
        return $null
    }
    catch {
        return $null
    }
}

function Test-YtDlp {
    try {
        $ytdlp = Get-Command yt-dlp -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Start-Download {
    param (
        [string]$url
    )
    
    # Verificar si el video ya fue descargado
    $historyPath = "history.json"
    if (Test-Path $historyPath) {
        $history = Get-Content $historyPath -Raw | ConvertFrom-Json
        if ($history | Where-Object { $_.url -eq $url }) {
            $global:Guide.Mood = "confused"
            Show-Guide
            Write-Host "`nEste video ya fue descargado anteriormente." -ForegroundColor Yellow
            Write-Host "`nPresiona cualquier tecla para continuar..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            return
        }
    }
    
    try {
        $global:Guide.Mood = "working"
        Show-Guide
        Write-Host "`nIniciando descarga..." -ForegroundColor Yellow
        
        $output = "downloads/%(title)s.%(ext)s"
        $info = yt-dlp -o $output $url --print-json | ConvertFrom-Json
        
        # Registrar la descarga en el historial con datos para APA
        $historyPath = "history.json"
        
        # Crear el archivo si no existe
        if (-not (Test-Path $historyPath)) {
            "[]" | Set-Content $historyPath
        }
        
        $entry = @{
            author = $info.uploader
            year = [datetime]::ParseExact($info.upload_date, "yyyyMMdd", $null).Year
            title = $info.title
            url = $url
            access_date = Get-Date -Format "yyyy-MM-dd"
        }
        
        $history = @(Get-Content $historyPath -Raw | ConvertFrom-Json)
        $history = $history + @($entry)
        $history | ConvertTo-Json -Depth 3 | Set-Content $historyPath
        
        $global:Guide.Mood = "happy"
        Show-Guide
        Write-Host "`n¡Descarga completada con éxito!" -ForegroundColor Green
        Write-Host "Registro guardado en history.json" -ForegroundColor Cyan
    }
    catch {
        $global:Guide.Mood = "sad"
        Show-Guide
        Write-Host "`nError durante la descarga: $_" -ForegroundColor Red
    }
}

function Get-APAReference {
    param (
        [PSCustomObject]$entry
    )
    return "$($entry.author) ($($entry.year)). $($entry.title) [Video]. YouTube. Recuperado el $($entry.access_date) de $($entry.url)"
}

function Initialize-Download {
    if (-not (Test-YtDlp)) {
        $global:Guide.Mood = "sad"
        Show-Guide
        Write-Host "`nError: yt-dlp no está instalado." -ForegroundColor Red
        Write-Host "Por favor instala yt-dlp antes de continuar." -ForegroundColor Yellow
        return
    }
    
    $url = Get-ClipboardUrl
    if (-not $url) {
        $global:Guide.Mood = "confused"
        Show-Guide
        Write-Host "`nNo se encontró un enlace válido de YouTube en el portapapeles." -ForegroundColor Red
        return
    }
    
    Start-Download -url $url
    
    # Mostrar referencia APA
    $history = Get-Content "history.json" -Raw | ConvertFrom-Json
    $lastEntry = $history[-1]
    Write-Host "`nReferencia APA:" -ForegroundColor Yellow
    Write-Host (Get-APAReference $lastEntry) -ForegroundColor Cyan
}
