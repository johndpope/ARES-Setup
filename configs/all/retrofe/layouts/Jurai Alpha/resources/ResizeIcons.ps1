$all = @()

# generation
$item = "" | select source,dest
$item.source = ".\generation\"
$item.dest = "..\collections\_common\medium_artwork\generation\"
$all += $item

# media
$item = "" | select source,dest
$item.source = ".\media\"
$item.dest = "..\collections\_common\medium_artwork\media\"
$all += $item

# type
$item = "" | select source,dest
$item.source = ".\type\"
$item.dest = "..\collections\_common\medium_artwork\type\"
$all += $item

# genre
$item = "" | select source,dest
$item.source = "..\..\..\collections\_common\medium_artwork\genre\"
$item.dest = "..\collections\_common\medium_artwork\genre\"
$all += $item

# numberPlayers
$item = "" | select source,dest
$item.source = "..\..\..\collections\_common\medium_artwork\numberPlayers\"
$item.dest = "..\collections\_common\medium_artwork\numberPlayers\"
$all += $item

# playlist
$item = "" | select source,dest
$item.source = "..\..\..\collections\_common\medium_artwork\playlist\"
$item.dest = "..\collections\_common\medium_artwork\playlist\"
$all += $item

# rating
$item = "" | select source,dest
$item.source = "..\..\..\collections\_common\medium_artwork\rating\"
$item.dest = "..\collections\_common\medium_artwork\rating\"
$all += $item

foreach ($folder in $all) {
  Write-Host $folder.source
  Write-Host $folder.dest
  new-item $folder.dest -itemtype directory
  $icons = Get-ChildItem $folder.source
  foreach($icon in $icons) {
    $sourcePath = $folder.source + $icon
    $destPath = $folder.dest + $icon
    Write-Host $sourcePath

    magick convert "$sourcePath" -resize "85x150>" "$destPath"
  }
}
