require 'rspec'
require File.expand_path("../lib/shell-proxy.rb", __FILE__)

describe "ShellProxy" do
  before(:each) do
    @proxy = ShellProxy.new
  end

  it "should write with __emit" do
    m = mock
    m.should_receive(:puts).with("test string")
    m.should_receive(:flush)
    @proxy.stub(:__writer => m)
    @proxy.__emit("test string")
  end

  it "should build a writer" do
    @proxy.__writer.should be_a ShellWriter
  end

end
