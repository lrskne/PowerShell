#http://herringsfishbait.com/2014/10/27/tagging-mp3-files-in-powershell/
param
    (
        [ValidateScript({Test-Path $_ -PathType Container})]
        [string]$Path="d:\media\flac",
        [string]$Pattern="\s\(CD(?'CD'\d+)\)"
        #Default pattern match looks for one or more digits
        #within '(CD' and ')'.  This is the named subgroup
        #CD
    )
$myDocumentsFolder = [Environment]::GetFolderPath("MyDocuments")
$scriptsFolder="\docs\scripts"
$MPTagFolder="\mptag"
#Import the MPTag module
Import-Module ($myDocumentsFolder+$scriptsFolder+$MPTagFolder)
#Get all the files
$MusicFiles=gci -recurse -Path $Path -File
foreach ($File in $MusicFiles)
{
    $MediaInfo=Get-MediaInfo $File.FullName
    if ($MediaInfo.Tag.Album -match $Pattern)
    {
        $MediaInfo.Tag.Disc=$Matches.CD
    }
    $NewAlbum=$MediaInfo.Tag.Album -replace $Pattern
    $DiscNumber=$MediaInfo.Tag.Disc
    if ($DiscNumber.Length -eq 1) {$DiscNumber="0"+$DiscNumber}
    $TrackNumber=$MediaInfo.Tag.Track
    if ($TrackNumber.Length -eq 1) {$TrackNumber="0"+$TrackNumber}
    $MediaInfo.Tag.Album=$NewAlbum
    $MediaInfo.Tag.Title=($DiscNumber+"-"+$TrackNumber+" "+$NewAlbum)
    $MediaInfo.Save()
    Rename-Item $File.FullName ($File.DirectoryName+"\"+$DiscNumber+"-"+$TrackNumber+" "+$NewAlbum+$File.Extension)
}