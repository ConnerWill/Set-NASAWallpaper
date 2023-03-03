$ProgressPreference = 'Continue'

Function Get-NASAImage(){

    $APODURL = "https://apod.nasa.gov/apod"
    $ProgressPreference = 'silentlyContinue'
    if (!(Test-Path "${env:USERPROFILE}\Pictures\apod")){
        mkdir "${env:USERPROFILE}\Pictures\apod"
    }
    $PICTURES_DIR = "${env:USERPROFILE}\Pictures\apod"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $APODURL -OutFile "C:\temp\apod.html"
    $returnImg = Select-String -Pattern jpg -Path "C:\temp\apod.html" | Select-Object -First 1
    $imgString = $returnImg.ToString(-split "`n")
    $resultImg = $imgString.Substring(30) -replace "..$"
    $imgURL = "${APODURL}/${resultImg}"
    Invoke-WebRequest -Uri ${imgURL} -OutFile "${PICTURES_DIR}\apod.jpg"
}

Function Set-NASABackground(){

    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name wallpaper -Value "${PICTURES_DIR}\apod.jpg"
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name TileWallpaper -Value "0"
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name WallpaperStyle -Value "10"
    $seconds=10
    ForEach ($count in (1..$seconds)){
        "$($seconds - $count)..."
        Start-Sleep -Seconds 1
    }
}

Function Update-Wallpaper(){

    rundll32.exe user32.dll, UpdatePerUserSystemParameters
}

Get-NASAImage
Set-NASABackground
Update-Wallpaper
