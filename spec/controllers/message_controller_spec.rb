require 'spec_helper'

describe MessageController do

  it "should use MessageController" do
    expect(controller).to be_an_instance_of(MessageController)
  end

  describe "post" do
    it "sould success to get /" do
      get 'index'
      expect(response).to be_success
    end

    it "should success to post /post" do
      post 'post', { :message => { :time => 10, :text => "hoge" } }
      expect(response).to redirect_to("/")
    end

    it "should fail to post /post" do
      post 'post', { :message => { :time => -1, :text => "hoge" } }
      expect(response).to render_template("index")
      expect(assigns(:message).errors.size).to eq(1)
    end
  end
end
