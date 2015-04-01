<#
.Synopsis
   #<This is just a rehash of a previous post of using YoutubeDL to parse playlists and 
download stuff, but here is doing it to download the European PowerShell Summit Videos.
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>

function Invoke-Main
{Out-Videos}
function Out-Videos
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $url
    )
	

  $script:playlisturl = $script:url
  <# 
    $script:videoUrls= (invoke-WebRequest -uri $script:playlisturl).Links | ? {$_.HREF -like '/watch*'} |  `
    ? innerText -notmatch '.[0-9]:[0-9].' | ? {$_.innerText.Length -gt 3} | Select-Object innerText, `
    @{Name='URL';Expression={'http://www.youtube.com' + $_.href}} | ? innerText -notlike '*Play all*' | ? innerText -notlike '*Play*'
  #> 
  $script:videoUrls  =  c:\mypowershelltools\youtube-dl.exe $script:url
  #$script:videoUrls
  
  ForEach ($video in $script:videoUrls){
    Write-Host ('Downloading ' + $video.innerText)
    .\youtube-dl.exe $script:video.URL
  }

}

. Invoke-Main

