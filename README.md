# Descargador de Videos de YouTube

¡Bienvenido al Descargador de Videos de YouTube! Esta aplicación te permite descargar videos de YouTube fácilmente y generar referencias APA automáticamente.

## Requisitos del Sistema

- Windows 10 o superior
- PowerShell 5.1 o superior
- [yt-dlp](https://github.com/yt-dlp/yt-dlp) instalado

## Instalación

1. Clona o descarga este repositorio
2. Asegúrate de tener yt-dlp instalado. Si no lo tienes, puedes instalarlo con:
   ```powershell
   pip install yt-dlp
   ```
3. Ejecuta `run.bat` para iniciar la aplicación

## Uso Básico

1. Copia la URL del video de YouTube que deseas descargar
2. Ejecuta la aplicación con `run.bat`
3. Selecciona la opción "Descargar video del portapapeles"
4. ¡Listo! El video se descargará en la carpeta `downloads`

## Funcionalidades

### Descargar Videos
- Descarga videos de YouTube directamente desde el portapapeles
- Verifica si el video ya fue descargado previamente

### Historial de Descargas
- Mantiene un registro de todos los videos descargados
- Permite ver el historial completo

### Generar Referencias APA
- Genera automáticamente referencias APA para los videos descargados
- Guarda las referencias en `references.txt` ordenadas alfabéticamente

## Ejemplos de Uso

### Descargar un Video
1. Copia la URL de un video de YouTube
2. Ejecuta la aplicación
3. Selecciona la opción 1

### Ver Historial
1. Ejecuta la aplicación
2. Selecciona la opción 2

### Generar Referencia APA
1. Ejecuta la aplicación
2. Selecciona la opción 3
3. Elige el video del historial
4. La referencia se guardará en `references.txt`

## Soporte

Si encuentras algún problema o tienes sugerencias, por favor abre un issue en el repositorio.

¡Disfruta descargando videos y generando referencias APA fácilmente!
