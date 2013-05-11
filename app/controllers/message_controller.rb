class MessageController < ApplicationController

  def index
    @message = Message.new
  end

  def post
    @message = Message.new post_params
    if @message.valid?
      @message.add_timer_with_redis
      redirect_to :action => 'index'
    else
      render :action => 'index'
    end
  end

  private

  def post_params
    params.require(:message).permit(:time, :text)
  end

end
