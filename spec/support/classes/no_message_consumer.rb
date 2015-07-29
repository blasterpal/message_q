class NoMessageConsumer < MessageQ::Consumer
  from_queue 'a-queue'
  def process_message
require 'pry';binding.pry
    GoodModel.new.do_something(message.to_hash)
  end
end

