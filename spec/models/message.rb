require File.dirname(__FILE__) + '/../spec_helper'
require 'msgpack'

describe Message do
  before(:each) do
    @message = Message.new
  end

  it "should be valid" do
    expect(@message).not_to be_valid
  end

  it "should be required time and text" do
    @message.time = 10
    @message.text = "hoge"
    expect(@message.key).to match(/\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/)
    expect(@message).to be_valid
  end

  it "should be tiem greater_than 0" do
    @message.text = "hoge"
    @message.time = 0
    expect(@message).not_to be_valid
    @message.time = -1
    expect(@message).not_to be_valid
    @message.time = 1
    expect(@message).to be_valid
  end

  it "should key unique" do
    expect(@message.key).not_to equal(Message.new.key)
  end

  it "should new_from_key_and_msgpack" do
    encoded = { :time => Time.now.to_i + 10, :text => "hoge" }.to_msgpack
    message = Message.new_from_key_and_msgpack("fuga", encoded)

    expect(message.text).to eq("hoge")
    expect(message.time).to eq(10)
    expect(message.key).to eq("fuga")
    expect(message).tp be_valid
  end
end
