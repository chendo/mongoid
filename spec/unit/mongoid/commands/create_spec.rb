require File.expand_path(File.join(File.dirname(__FILE__), "/../../../spec_helper.rb"))

describe Mongoid::Commands::Create do

  describe "#execute" do

    before do
      @document = stub(:run_callbacks)
    end

    it "executes a save command" do
      Mongoid::Commands::Save.expects(:execute).with(@document).returns(@document)
      Mongoid::Commands::Create.execute(@document)
    end

    it "runs the before and after create callbacks" do
      @document.expects(:run_callbacks).with(:before_create)
      Mongoid::Commands::Save.expects(:execute).with(@document).returns(@document)
      @document.expects(:run_callbacks).with(:after_create)
      Mongoid::Commands::Create.execute(@document)
    end

    it "returns the document" do
      Mongoid::Commands::Save.expects(:execute).with(@document).returns(@document)
      Mongoid::Commands::Create.execute(@document).should == @document
    end

  end

end
