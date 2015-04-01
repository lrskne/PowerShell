<#
  .SYNOPSIS
  This works - depending on goal - change the code a bit

  Depends on dowloading a module from internet!!! 

  .DESCRIPTION
  <A detailed description of the script>
  .PARAMETER <paramName>
  <Description of script parameter>
  .EXAMPLE
  <An example of using the script>
#>
function Invoke-Main
{
  $lessons = 'C:\Users\Oceana\Music\SpanishMom'
  'start script'
  New-Title $lessons
  'end script'
}

function New-Title
 {
  param
     (
        [ValidateScript({Test-Path $_ -PathType Container})]
        [string]$Path= 'C:\Users\Oceana\Music\SpanishMomDay01'
  )
    #Get all the files
    #$MusicFiles=gci -recurse -Path $Path -File
    $MusicFiles=gci -recurse -Path $Path -File
    foreach ($File in $MusicFiles)
    {
      $MediaInfo=Get-MediaInfo $File.FullName
      

      $friendlyTitle = ($MediaInfo.Title -split ':', 2)[1]
      $NewAlbum = "MoMDay"
      $Artist = "Timothy Moser"
      $TrackNumber = $MediaInfo.Tag.Track
     
      
      # Change the disknumber later, have to go through and
      # see whichday each mp3 belongs to
      #$DiscNumber=$MediaInfo.Tag.Disc
  
      #if ($DiscNumber.Length -eq 1) {$DiscNumber="0"+$DiscNumber}
      
      # Track numbers are all ok for Mom
          
        if ($TrackNumber -lt 10) {
          $TrackChar ='0'+ $TrackNumber.ToString()
        }
        else {
          $TrackChar = $TrackNumber.ToString()
        }
        
      $trackAlbum = $TrackChar + " " + $NewAlbum
      $title = $trackAlbum + $friendlyTitle
      $MediaInfo.Tag.Artists = $Artist
      $MediaInfo.Tag.Album=$NewAlbum
      #$MediaInfo.Tag.Title=($DiscNumber+"-"+$TrackNumber+" "+$NewAlbum)
      $MediaInfo.Tag.Title= $title
      
      'So what do you have'
      "Track: $($MediaInfo.Tag.Track)"
      "Title: $($MediaInfo.Tag.Title)"
      "Album: $($MediaInfo.Tag.Album)"
      "Artist:$($MediaInfo.Tag.Artists)"
      
      
      
      $MediaInfo.Save()
      Rename-Item $File.FullName ($File.DirectoryName+"\"+$title+$File.Extension)
      
      #Rename-Item $File.FullName ($File.DirectoryName+"\"+$DiscNumber+"-"+$TrackNumber+" "+$NewAlbum+$File.Extension)
    } 
  }

    function Old-Title
  {
  
    $MusicFiles=Get-ChildItem $lessons -File | Sort-Object Name
   
   
   
    foreach ($File in $MusicFiles)
    {
      "Processing $($File.BaseName)"
      $MediaInfo=Get-MediaInfo $File.FullName
      
      $DiscNumber = '01'          
      $MediaInfo.Disc = $DiscNumber
      

      $Track =  $MediaInfo.Tag.Track
     
      $MediaInfo.Save()
      

       #Rename-Item $File.FullName ($File.DirectoryName + '\' + $DiscNumber + '-' + $Track + ' ' + $NewAlbum)
       $TrackNumber++
  
    }

  }


  . Invoke-Main
  