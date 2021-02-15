Function Set-WallPaper {
 
<#
 
    .SYNOPSIS
    Applies a specified wallpaper to the current user's desktop
    
    .PARAMETER Image
    Provide the exact path to the image
 
    .PARAMETER Style
    Provide wallpaper style (Example: Fill, Fit, Stretch, Tile, Center, or Span)
  
    .EXAMPLE
    Set-WallPaper -Image "C:\Wallpaper\Default.jpg"
    Set-WallPaper -Image "C:\Wallpaper\Background.jpg" -Style Fit
  
#>
 
param (
    [parameter(Mandatory=$True)]
    # Provide path to image
    [string]$Image,
    # Provide wallpaper style that you would like applied
    [parameter(Mandatory=$False)]
    [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
    [string]$Style
)
 
$WallpaperStyle = Switch ($Style) {
  
    "Fill" {"10"}
    "Fit" {"8"}
    "Stretch" {"2"}
    "Tile" {"0"}
    "Center" {"0"}
    "Span" {"22"}
  
}
 
If($Style -eq "Tile") {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force
 
}
Else {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
 
}
 
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
  
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
  
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
  
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}


$response = Invoke-RestMethod -Uri https://limitless-springs-58826.herokuapp.com/wod/today -Method Get;

Write-Output $response.wordOfDay;

Add-Type -AssemblyName System.Drawing

$filename = "$home\foo.png" 
$bmp = new-object System.Drawing.Bitmap 1500,500 
$font = new-object System.Drawing.Font Consolas,36 
$fontMeaning = new-object System.Drawing.Font Consolas,14
$fontExample = new-object System.Drawing.Font Consolas,15
$brushBg = [System.Drawing.Brushes]::white 
$brushFg = [System.Drawing.Brushes]::Black

$graphics = [System.Drawing.Graphics]::FromImage($bmp) 
$graphics.FillRectangle($brushBg,0,0,$bmp.Width,$bmp.Height) 
$rect = [System.Drawing.RectangleF]::FromLTRB(0, 0, $bmp.Width, $bmp.Height)
$rectMeaning = [System.Drawing.RectangleF]::FromLTRB(0, 0, $bmp.Width, $bmp.Height+100)
$reactExample = [System.Drawing.RectangleF]::FromLTRB(0, 0, $bmp.Width, $bmp.Height+200)
$format = [System.Drawing.StringFormat]::GenericDefault
$format.Alignment = [System.Drawing.StringAlignment]::Center
$format.LineAlignment = [System.Drawing.StringAlignment]::Center
$graphics.DrawString($response.wordOfDay,$font,$brushFg,$rect,$format) 
$graphics.DrawString($response.meaning,$fontMeaning,$brushFg,$rectMeaning,$format);
$graphics.DrawString($response.example,$fontExample,$brushFg,$reactExample,$format);
$graphics.Dispose() 
$bmp.Save($filename);
$bmp.Dispose();

Invoke-Item $filename 

Set-WallPaper -Image $filename -Style Center