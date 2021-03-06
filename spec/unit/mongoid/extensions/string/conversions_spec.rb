require File.expand_path(File.join(File.dirname(__FILE__), "/../../../../spec_helper.rb"))

describe Mongoid::Extensions::String::Conversions do

  describe "#set" do
    it "returns the object to_s" do
      String.set(1).should == "1"
    end
  end

  describe "#get" do
    it "returns the string" do
      String.get("test").should == "test"
    end
  end

end
