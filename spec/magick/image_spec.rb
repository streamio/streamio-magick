require 'spec_helper'

module Magick
  describe Image do
    context "given a non existing file" do
      it "should throw ArgumentError" do
        lambda { Image.new("i_dont_exist") }.should raise_error(Errno::ENOENT, /does not exist/)
      end
    end
    
    describe "parsing" do
      context "given a non image file" do
        before(:all) do
          @image = Image.new(__FILE__)
        end

        it "should not be valid" do
          @image.should_not be_valid
        end
      end
      
      context "given a jpg file" do
        before(:all) do
          @image = Image.new("#{fixture_path}/awesome.jpg")
        end
        
        it "should remember the image path" do
          @image.path.should == "#{fixture_path}/awesome.jpg"
        end
        
        it "should know the file size" do
          @image.size.should == 72467
        end
        
        it "should be valid" do
          @image.should be_valid
        end
        
        it "should parse the width" do
          @image.width.should == 640
        end
        
        it "should parse the height" do
          @image.height.should == 512
        end
        
        it "should parse the codec" do
          @image.codec.should == "JPEG"
        end
      end
      
      context "given a gif file" do
        before(:all) do
          @image = Image.new("#{fixture_path}/awesome.gif")
        end
        
        it "should be valid" do
          @image.should be_valid
        end
        
        it "should parse the width" do
          @image.width.should == 500
        end
        
        it "should parse the height" do
          @image.height.should == 500
        end
        
        it "should parse the codec" do
          @image.codec.should == "GIF"
        end
      end
      
      context "given a png file" do
        before(:all) do
          @image = Image.new("#{fixture_path}/awesome.png")
        end
        
        it "should be valid" do
          @image.should be_valid
        end
        
        it "should parse the width" do
          @image.width.should == 234
        end
        
        it "should parse the height" do
          @image.height.should == 288
        end
        
        it "should parse the codec" do
          @image.codec.should == "PNG"
        end
      end
    end
    
    describe "transcoding" do
      before(:each) do
        @image = Image.new("#{fixture_path}/awesome.jpg")
      end
      
      context "to an impossible location" do
        it "should raise error" do
          expect { @image.transcode("/i/dont/exist.jpg") }.to raise_error(/convert:/)
        end
      end
      
      context "to a png" do
        before(:each) do
          @transcoded_image = @image.transcode("#{tmp_path}/awesome.png")
        end
        
        it "should change the codec" do
          @transcoded_image.codec.should == "PNG"
        end
        
        it "should not change the resolution" do
          @transcoded_image.width.should == @image.width
          @transcoded_image.height.should == @image.height
        end
      end
      
      context "with resize option" do
        before(:each) do
          @transcoded_image = @image.transcode("#{tmp_path}/awesome.png", "-resize 320x240")
        end
        
        it "should change the resolution" do
          @transcoded_image.width == 320
          @transcoded_image.height == 240
        end
      end
    end
  end
end
