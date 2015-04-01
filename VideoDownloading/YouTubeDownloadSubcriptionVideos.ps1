<#
.Synopsis
    YouTubeDownloadSubscriptionVideos.ps1

    
  Purpose: Move all files in one directory to another directory,
  and create thother directory if it does not exist

.DESCRIPTION
   Long description
.EXAMPLE
   script name https://www.youtube.com/playlist?list=PLPD6O-TouCqTTN9e2HfzWau2m7ocbfdp5

   This downloads a playlist from Senior Jordan Videos

.EXAMPLE
   Example tbd
.NOTES
  Pass in -SwitchSingle if you want to run the single file logic

  What does this script do?

 
  Script works great. Keep in mind if making any changes, the location of the yldownload.exe seems to matter ( for example
  it may not have worked that well when in the c:\windows\system32 directory. ( Note it is just a copy of the exe off
  webiste!

  How to use: directly in script (for now :) ) enter in the url that has the list of videos you want to download

  Enhancements that could be nice:
  Progress bar (with Write-Progress )
  Pipeline or parameterize the playlist url

  # source: http://foxdeploy.com/2014/07/08/download-a-full-youtube-playlist-with-powershell/
  # and https://github.com/rg3/youtube-dl/blob/master/README.md#readme

  # for help with youtube-dl.exe - see https://github.com/rg3/youtube-dl/blob/master/README.md#readme

  Note you can get help on c:\mypowershelltools\youtube-dl.exe as follows

  c:\mypowershelltools\youtube-dl.exe -h

  #region youtube-dl --h output
  Usage: youtube-dl.exe [OPTIONS] URL [URL...]

#>
[CmdletBinding()]
[OutputType([int])]
Param
    (
        # link YouTube playlist url
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $link,

        # dLeaf - subdirectory under Videos place the output (\temp is the default)
                [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)][string]
        $dLeaf = 'temp',

        
        # switchSingle - True if just one video
        [bool]
        j$switchSingle = $false
    )
function Invoke-Main 
{

  clear-host
  write-host 'Script started' -ForegroundColor Red
  #region initialize variables
 
  $global:VideoUrls = @()
  $videoProcessCt = 0
  
  #endregion initialize variables
   
   $outputDir = "$HOME" + '\Videos\' + $dLeaf
  
  
  # ***************************************************************************************************
  #end region script variables
  
  
  Write-Host 'Input Playlisturl and Output Directory'
  "`t $link"
  "`t $outputDir"

  
 
  New-outputDir
  
  if ($switchSingle) {
    'Processing single video logic'
     Out-SingleVideo 
  }
  else
  {
    'Processing multiple video logic'
    Out-MultipleVideos    
  }      
  
    
  write-host 'Script ended' -ForegroundColor Red
}


function Out-SingleVideo
{
 
  
  set-location $outputDir
  Write-Warning "Script is changing the set-location to $outputDir"
    
  $global:rm = ( c:\mypowershelltools\youtube-dl.exe --max-quality FORMAT $link)
  $videoProcess = 1

}
function Out-MultipleVideos  
{

  "The link being processed is: $link"  
  $global:VideoUrls= (invoke-WebRequest -uri $link).links | ? {$_.HREF -like '/watch*'} | ` 
  ? innerText -notmatch '.[0-9]:[0-9].' | ? {$_.innerText.Length -gt 3} | Select-Object innerText, ` 
  @{Name='URL';Expression={'http://www.youtube.com' + $_.href}} | ? innerText -notlike '*Play all*'
  

  
  if ($global:VideoUrls.Count -eq 0 ) {
    write-warning '  No videos to process - exiting routine'
    return
   }
   else
   {
    "  About to process: $($global:VideoUrls.Count) videos"
   }

  
    
    
  set-location $outputDir
  Write-Warning "Script is changing the set-location to $outputDir"
    
  ForEach ($video in $($global:VideoUrls)) {
    Write-Progress "Downloading video #$($videoProcessCt): ' + $($video.innerText) $($video.URL)"
    'Input video.URL is: '
    $video.URL
    
    
    
    c:\mypowershelltools\youtube-dl.exe --max-quality FORMAT $video.URL
    
    
    
    
    
    
    $videToProcessCt++

  }

}

function New-outputDir
{

  if (Test-Path $outputDir ) {
    'Output directory exist, so creation not needed...'
  }
  else
  {
    new-item -ItemType Directory $outputDir -force
    
    'created output directory'
  }
}

function Show-Output
{
  $videoProcessCt
  get-childitem $outputDir
}

. Invoke-Main
