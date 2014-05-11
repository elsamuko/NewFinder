NewFinder
=========

Helper script, which opens a new Finder window

Build steps
===========

 * Export the file Icon.svg as 1024 x 1024 Icon.png with inkscape
 * Convert the png into a iconset with png2icns.sh Icon.png
 * Compile the apple script into an app with compile.sh NewFinder.scpt
 * Open the info dialog of the created app (⌘-I)
 * Drop there the iconset Icon.icns
 * Done!
 
 
