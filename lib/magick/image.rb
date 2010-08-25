# Output example:
# file.ext JPEG 1920x1200 1920x1200+0+0 8-bit DirectClass 1.955MB 0.000u 0:00.000
# Error example:
# identify: no decode delegate for this image format `file.ext' @ error/constitute.c/ReadImage/532.

class Magick::Image
  attr_reader :width, :height, :codec, :path, :size
  
  def initialize(path)
    raise Errno::ENOENT, "the file '#{path}' does not exist" unless File.exists?(path)
    
    @path = escape(path)
    @size = File.size(path)
    
    stdin, stdout, stderr = Open3.popen3("identify '#{path}'") # Output will land in stderr

    out = stdout.read
    err = stderr.read
    
    @valid = out.length > 0
    
    if valid?
      filename, @codec, resolution, etc = out.split
      
      @width = resolution.split("x").first.to_i
      @height = resolution.split("x").last.to_i
    end
  end
  
  def valid?
    @valid
  end
  
  def transcode(output_file, parameters = "")
    stdin, stdout, stderr = Open3.popen3("convert #{path} #{escape(parameters)} #{output_file}")
    
    out = stdout.read
    err = stderr.read
    
    raise err if err.length > 0
    
    self.class.new(output_file)
  end
  
  protected
  def escape(path)
    map  =  { '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n', "\r" => '\n', '"' => '\\"' }
    path.gsub(/(\\|<\/|\r\n|[\n\r"])/) { map[$1] }
  end
end
