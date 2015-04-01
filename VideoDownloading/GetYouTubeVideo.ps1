<#
https://msdn.microsoft.com/en-us/library/microsoft.powershell.commands.psuseragent%28v=vs.85%29.aspx
Namespace: Microsoft.PowerShell.Commands
Assembly: Microsoft.PowerShell.Commands.Utility (in Microsoft.PowerShell.Commands.Utility.dll)
#>
function Invoke-Main
{
# original source: http://jacob.ludriks.com/downloading-from-youtube-using-powershell/

get-One  'http://masterofmemory.com/spanish-fluency-day-1/'
#`,https://www.youtube.com/watch?v=27PqTadLJx'
}
function get-One
{
Param (
    [Parameter(Mandatory = $True)]
    [string]$video
)
$quality = @{}
$quality['5'] = @{
    'ext'  = 'flv'
    'width' = 400
    'height' = 240
}
$quality['6'] = @{
    'ext'  = 'flv'
    'width' = 450
    'height' = 270
}
$quality['13'] = @{
    'ext' = '3gp'
}
$quality['17'] = @{
    'ext'  = '3gp'
    'width' = 176
    'height' = 144
}
$quality['18'] = @{
    'ext'  = 'mp4'
    'width' = 640
    'height' = 360
}
$quality['22'] = @{
    'ext'  = 'mp4'
    'width' = 1280
    'height' = 720
}
$quality['34'] = @{
    'ext'  = 'flv'
    'width' = 640
    'height' = 360
}
$quality['35'] = @{
    'ext'  = 'flv'
    'width' = 854
    'height' = 480
}
$quality['36'] = @{
    'ext'  = '3gp'
    'width' = 320
    'height' = 240
}
$quality['37'] = @{
    'ext'  = 'mp4'
    'width' = 1920
    'height' = 1080
}
$quality['38'] = @{
    'ext'  = 'mp4'
    'width' = 4096
    'height' = 3072
}
$quality['43'] = @{
    'ext'  = 'webm'
    'width' = 640
    'height' = 360
}
$quality['44'] = @{
    'ext'  = 'webm'
    'width' = 854
    'height' = 480
}
$quality['45'] = @{
    'ext'  = 'webm'
    'width' = 1280
    'height' = 720
}
$quality['46'] = @{
    'ext'  = 'webm'
    'width' = 1920
    'height' = 1080
}
 
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
$content = Invoke-WebRequest -Uri $video -UserAgent $userAgent
$title = $content | Select-String -Pattern '(?i)<title>(.*)<\/title>' |
ForEach-Object -Process {
    $_.matches.groups[1].value 
}
$html = $content | Select-String -Pattern '"url_encoded_fmt_stream_map":\s"(.*?)"' |
ForEach-Object -Process {
    $_.matches.groups[1].value 
}
$html = $html -replace '%3A', ':'
$html = $html -replace '%2F', '/'
$html = $html -replace '%3F', '?'
$html = $html -replace '%3D', '='
$html = $html -replace '%252C', '%2C'
$html = $html -replace '%26', '&'
$html = $html -replace '\\u0026', '&'
#$urls = $html.split(',')
$urls |
Select-String -Pattern 'itag=(\d+)' |
ForEach-Object -Process {
    $val = $_.matches.groups[1].value
    Write-Host $val") Extension:" $quality[$val].ext 'Dimensions:' $quality[$val].width'x'$quality[$val].height
}
$itag = Read-Host -Prompt 'Which quality do you want to download in?'
foreach ($url in $urls) 
{
    $string = "itag=$itag"
    if ($url -match $string) 
    {
        $signature = $url |
        Select-String -Pattern '(s=[^&]+)' |
        ForEach-Object -Process {
            $_.matches.groups[1].value 
        }
        $url = $url |
        Select-String -Pattern '(http.+)' |
        ForEach-Object -Process {
            $_.matches.groups[1].value 
        }
        $url = $url -replace '(type=[^&]+)', ''
        $url = $url -replace '(fallback_host=[^&]+)', ''
        #$url = $url -replace "(quality=[^&]+)",""
        $download = $url
        $download = $download -replace '&+', '&'
        $download = $download -replace "&$", ''
        $download = $download -replace '&itag=\d+', ''
        $download = "$download&itag=$itag"
        Invoke-WebRequest -Uri $download -OutFile "$HOME\VIDEOS\SENIORJORDAN\$title.$($quality[$itag].ext)" -UserAgent $userAgent
    }
}


} # end of get-one function

. Invoke-Main
 