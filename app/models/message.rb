class Message
  include ActiveModel::Model
  include ActiveModel::ForbiddenAttributesProtection

  attr_accessor :time, :text, :key

  validates :time, presence: true, numericality: { :greater_than => 0 }
  validates :text, presence: true

  def self.new_from_key_and_msgpack(key, msgpack)
    hash = MessagePack.unpack(msgpack)
    hash["time"] -= Time.now.to_i
    hash["key"]   = key
    self.new hash
  end

  def self.restore
    $redis.hgetall("timer").each_pair do |key, msgpack|
      begin
        message = Message.new_from_key_and_msgpack(key, msgpack)
        unless message.valid?
          $redis.hdel("timer", key)
          next
        end
        message.add_timer
      rescue => e
        p e
      end
    end
  end

  def key
    @key ||= UUIDTools::UUID.random_create.to_s
  end

  def add_timer_with_redis
    save_to_redis
    add_timer
  end

  def add_timer
    EM.add_timer(time) do
      http = EventMachine::HttpRequest.new(ENV["POST_URL"]).post :body => { :text => text }
      http.callback {
        $redis.hdel("timer", key)
      }
      http.errback {
        $redis.hdel("timer", key)
      }
    end
  end

  def save_to_redis
    encoded = { :time => Time.now.to_i + time.to_i, :text => text }.to_msgpack
    $redis.hset("timer", key, encoded)
  end
end
