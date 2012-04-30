# Output example:
# file.ext JPEG 1920x1200 1920x1200+0+0 8-bit DirectClass 1.955MB 0.000u 0:00.000
# Error example:
# identify: no decode delegate for this image format `file.ext' @ error/constitute.c/ReadImage/532.

require 'shellwords'

class Magick::Image
  attr_reader :width, :height, :codec, :path, :size
  
  def initialize(path)
    raise Errno::ENOENT, "the file '#{path}' does not exist" unless File.exists?(path)
    
    @path = path
    @size = File.size(path)
    
    out = Open3.popen3("identify #{Shellwords.escape(path)}") { |stdin, stdout, stderr| stdout.read }
    @valid = out.length > 0
    
    if @valid
      filename, @codec, resolution, etc = out.split
      
      @width = resolution.split("x").first.to_i
      @height = resolution.split("x").last.to_i
    end
  end
  
  def valid?
    @valid
  end
  
  def transcode(output_file, parameters = "")
    err = Open3.popen3("convert #{Shellwords.escape(path)} #{parameters} #{Shellwords.escape(output_file)}") { |stdin, stdout, stderr| stderr.read }
    
    raise Magick::Error, err if err.length > 0
    
    self.class.new(output_file)
  end
end
