require 'uuidtools'

class Message
  include ActiveModel::Model

  attr_accessor :time, :text, :key

  validates_presence_of :time
  validates_numericality_of :time, :greater_than => 0
  validates_presence_of :text

  def key
    @key ||= UUIDTools::UUID.random_create.to_s
  end
end
