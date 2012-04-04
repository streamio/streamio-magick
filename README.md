Streamio Magick
###############

Simple yet powerful wrapper around imagemagick cli tools for reading metadata and transcoding images.

Installation
------------

    (sudo) gem install streamio-magick

You also need to make sure to have imagemagick installed and that the commands identify and convert are available to the ruby process.

This version is written against an imagemagick build from august 2010. So no guaranteed compatability with much earlier (or much later) versions.

Usage
-----

### Require the gem

```ruby
require 'rubygems'
require 'streamio-magick'
```

### Reading Metadata

```ruby
image = Magick::Image.new("path/to/image.png")

image.width # 640 (width of the image in pixels)
image.height # 480 (height of the image in pixels)
image.size # 455546 (filesize in bytes)
image.codec # "PNG"

image.valid? # true (would be false if identify fails to read the image)
```

### Transcoding

First argument is the output file path.

```ruby
image.transcode("image.jpg") # Transcode to jpg format
```

Give custom command line options for the convert command with a string.

```ruby
image.transcode("image.jpg", "-resize 320x240")
```

The transcode function returns an Image object for the encoded file.

```ruby
transcoded_image = image.transcode("image.jpg", "-resize 320x240")
```

```ruby
transcoded_image.width # 320
transcoded_image.height # 240
transcoded_image.codec # "JPEG"
```

Rescue from Magick::Error if something goes wrong during transcoding.

```ruby
begin
  image.transcode("image.jpg")
rescue Magick::Error => e
  # handle error
end
```

Copyright
---------

Copyright (c) Streamio Networks AB. See LICENSE for details.
