--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Jurai Alpha 1.0 (March 2019)
 By Duke Paulus
 Use with retrofe 0.8.18 and above
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Credits

genre, numberPlayers, playlist, and rating icons were taken from the base RetroFE install by Pieter Hulshoff (retrofe.nl) and resized to the native
size at which they get presented when running in 1920x1080 resolution. 

Intro video borrowed generally from other RetroFE themes.

Base artwork for new icons sourced from chittagongit.com and shareicon.net

-- About the Layout

This is a clean, simple theme that minimizes the use of static graphical elements and maximizes use of system, game, and category artwork.

Both 16x9 and 4x3 variants of the layout are provided. The 4x3 layout eschews much of the whitespace alloted to the edge of the screen by its 16x9
counterpart, and reduces the size of the center area.

There is no separate styling between the main menu and sub-menus. They both share the same style.

The screen is divided into several zones:
Top (Menu) Zone - A logo menu with three items visible: the current item, the next item, and the previous item. Medium-weight semi-transparent
triple chevrons atop the next and previous item provide discoverability of menu navigation.

Central (Showcase) Zone - Showcases either the device artwork or the box artwork for the current item, gently animated.

Top Left (Story) Zone - shows the story information for the current item in a scrolling text box.

Lower Left (Media) Zone - shows the disc or cartridge artwork for the current item.

Upper Right (Video) Zone - shows the preview video of the current item

Lower Right (Information) Zone - Shows textual information for release date, maufacturer, and developer for games, and release date, manufacturer,
and CPU for systems. Shows iconic information for system type, generation, and media type for systems, and genre, players, rating, and playlist for
games.

Bottom (Status) Zone - shows the title of the current item, the logo of the current system, and the current index and size of the collection.

The background shows a portion of the zoomed-in preview video.

Text is either set on a translucent black background, or rendered with a drop shadow to keep the text from getting lost in the background.

-- Known issues
Release date information can pretty easily overflow its alotted field, especially if full dates for multiple regoions are used. 
If both the developer and cpu are defined for a system, the text for both will overlap.
Animated showcase art and chevrons ping-pong instead of easing at movement extremeties. This is thought to be a bug with RetroFE (Issue #32).

-- The Original Icon Sets

This layout provides icon sets for system type, generation, and media type. Of course, in order for these icons to be used, the metadata for the
systems in info.conf must match. The icons are styled to be similar to the genre icons that are included in RetroFE. The (Paint.net) template for
these icons and the chevron images, as well as full-sized versions of the icons, are provided in the "resources" folder.

System type icons provided:
"Arcade Machines"
"Computer"
"Video Game Console Add-on" (for devices like Famicom Disk System, Sega CD, Sega 32x, etc.)
"Handheld Game Console"
"Hybrid Video Game Console and Gaming PC" (For example, Amiga CD32)
"Video Game Console"

Generation icons provided:
"Second Generation"
"Third Generation"
"Fourth Generation"
"Fifth Generation"
"Sixth Generation"
"Seventh Generation"
"Eighth Generation"
"Ninth Generation" (for future use)

Media icons provided:
"Cartridge"
"Cassette Tape"
"Floppy Disk"
"Optical Disc"
"Optical Disc, Digital Download"
"VHS Cassette"

-- The Resized RetroFE icon sets

RetroFE seems to use point filtering when resizing images. The upside to this is that it is fast, and keeps images sharp when upscaling. The downside
to this is that resized images can look grainy and aliased, and text such as that on the icons can become illegible more quickly (than with other
resizing algorithms) as the icons get smaller. One way to account for this and improve the look of the icons without sacrificing performance is to
pre-size the images to the native size at which they will be used. This way, RetroFE does not need to resize the icons at all.

Thus I have batch-resized all of the RetroFE-included icons that the layout uses to the native pixel width used by the layout when running at
1920x1080 resolution. For convenience, I have included the resized icons.

-- The icon resizing script

But wait, there's more. I've also included the PowerShell script (quickly thrown together) that I used to batch-resize all of the icons. The script
uses ImageMagick, which you must obtain/install elsewhere (it's free). ImageMagick does a really good high quality job with resizing images en masse.
The script is named ResizeIcons.ps1 and resides in the resources folder. Some errors regarding directories already existing can be expected, as well
as a likely "permission denied" error when the dumb script bumbles into a backup folder in the numberPlayers folder.

To change the size used, simply edit the value after the "-resize" parameter in the call to "magick" at the bottom of the script, and run the
script using the resources folder as the working directory.
Some common resolutions and corresponding sizes:
3840x2160 (4KHD) : 170
1920x1080 (HD)   : 85
1280x720 (HD)    : 57
1600x1200 (4:3)  : 94
1024x768 (4:3)   : 60

720 vertical resolution is about the tested minimum for being able to read the icons. At 600 vertical resolution, enough legibility is lost that it
just looks bad, IMO, and you should probably consider different icons.

-- Final thoughts

I'm really happy with how the layout turned out. It ticks all of my boxes, hopefully for some out there it will do the same.

RetroFE really is an excellent front-end. At the time I built this layout, I had only been using RetroFE for less than a week. That I was able to
put together this layout in so little time while learning the system is a testament to how powerful and expressive the layout engine is.

There are a couple of things I would have liked to do for this layout that do not seem to be currently possible, such as enabling/disabling
components based on whether the current item is a game or submenu link, constructing a formatted string to display, sizing text to fit an area,
suppressing horizontal scrolling for content that fits like it does for vertical scrolling, conditionally changing a property value based on whether
an item exists, and other minor things. But RetroFE is still evolving, so likely I will be able to do some of these things in the future.
