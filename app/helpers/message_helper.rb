module MessageHelper
  def rest_time_message(message)
    if message.time < 60 * 60 * 24 * 7
      "within 1 week"
    elsif message.time < 60 * 60 * 24 * 31
      "within 1 month"
    else
      "over 1 month"
    end
  end
end
