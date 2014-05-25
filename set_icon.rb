#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby

require 'osx/cocoa'
include OSX
raise ArgumentError, %Q[Usage: $0 <file> <image file>] unless ARGV.length == 2
file, imagef = ARGV
image = NSImage.alloc.initWithContentsOfFile(imagef)
NSWorkspace.sharedWorkspace.objc_send(
    :setIcon, image,
    :forFile, file,
    :options, 0)

