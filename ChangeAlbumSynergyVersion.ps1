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



  
<#
One of my main familial duties is as CD-Ripping monkey.  Once we get a CD I need to convert it into a format friendly for the various streamers, phones, players, alarm-clocks and secret digital diaries (yes, really).  This usually just involves ripping an album to Flac and MP3 and uploading it to the file-server.

Some audio-books and multi-CD albums are more difficult though;  the more CDs there are the more chance that iTunes or the FreeDB databases have mismatches of metadata between the discs (maybe CD #1s album title is “Status Quo Greatest Hits CD1′ and CD#9s album title is ‘Status Quo – Greatest Hits (CD 9)’).  Clearly mismatched metadata is a crime against humanity and I can’t leave it uncorrected.

You can only imagine how diabolical the Harry Potter Unabridged audiobooks are;  each has 25+ CDs with with 50-70 files per disc.  When we get a new-one they often sit on my desk for days, taunting me while I choke back a sob and try not to remember the manual corrections required the last time I converted one.

This time my PowerShell-fu is strong and it comes to the rescue with some automatic tagging.  The details are below.


First off the bat, PowerShell doesn’t have any inbuilt cmdlets for manipulating media file tags like Album, Track Number and Disc.  But what PowerShell does have is a robust system for creating and importing new modules that reference .NET DLL files.

With a bit of Google-fu I found a link to someone who created a nice PowerShell module that does exactly that.  The link is here.

The main problem I was trying to solve was that with an inconsistent naming conventio often the tracks would play in the wrong order.  To compound matters, we found certain devices used the file name, some used the track name / album name and some used the album name and metadata (track number and disc number) to sort.  The only way to make everyone work was to make everything nicely sorted.

So for the Harry Potter audiobooks, I wanted the file and title name to be of the format “[Track Number]-[Disk Number] Title”, ie “01-07 Harry Potter and Order of the Phoenix”.  It was important the track and disk numbers were two characters wide (ie, “01” instead of “1”) as you could get all sorts of problems with track 2 playing after track 20, for example.  Additionally, all the files should be in the same folder, shouldn’t have the CD number in the title and the relevant metadata should be correct.

Here’s the script to make it happen;

#>
#>
function Invoke-Main
{
  'start script'
   Set-Item -Value $env:lessons -Path 'C:\Users\Oceana\Music\SynergySpanishCD06'
   New-Title $lessons
  'end script'

  
}

  function New-Title
  {
  
    param
    (
        [ValidateScript({Test-Path $_ -PathType Container})]
        [string]$Path= 'C:\users\Oceana\Music\PimsleurCourse1'
 
    )


    $MusicFiles=Get-ChildItem -Path $Path -File | Sort-Object Name
    
    foreach ($File in $MusicFiles)
    {
      "Processing $($File.BaseName)"
      $MediaInfo=Get-MediaInfo $File.FullName
      
                
      $NewAlbum = $($Path.Leaf)  
         
      $MediaInfo.Tag.Album =$NewAlbum
      "set new album name to $NewAlbum"
      
      
      'Show NEW Album name'
      $MediaInfo.Tag.Album

     
      #$MediaInfo.Save()
      
    }
  }
  . Invoke-Main
  