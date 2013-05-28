require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the MessageHelper. For example:
#
# describe MessageHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe MessageHelper do
  before(:each) do
    @message = Message.new
  end

  context "rest_time_message" do
    it "1 hour" do
      @message.time = 60 * 60
      expect(helper.rest_time_message(@message)).to eq("within 1 week")
    end

    it "1week - 1sec" do
      @message.time = 60 * 60 * 24 * 7 - 1
      expect(helper.rest_time_message(@message)).to eq("within 1 week")
    end

    it "1week" do
      @message.time = 60 * 60 * 24 * 7
      expect(helper.rest_time_message(@message)).to eq("within 1 month")
    end

    it "31 days - 1 sec" do
      @message.time = 60 * 60 * 24 * 31 - 1
      expect(helper.rest_time_message(@message)).to eq("within 1 month")
    end

    it "31 days" do
      @message.time = 60 * 60 * 24 * 31
      expect(helper.rest_time_message(@message)).to eq("over 1 month")
    end
  end
end
