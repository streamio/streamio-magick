require 'spec_helper'

describe Magick do
  it "should have a version constant" do
    Magick::VERSION.should >= "0.0.0"
  end
end
