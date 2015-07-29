class GoodModel
  def do_something(message)
    message[:some_field].upcase
  end
end

class SomeCoolEventMessage < MessageQ::BaseMessage 
  attr_accessor :some_field
  def initialize(attrs={})
    attrs = attrs.symbolize_keys!
    @some_field = attrs[:some_field]
    super(attrs)
  end
  def validate
    errors.add(:some_field, 'has a problemo') if self.some_field.blank?
  end
end

class NoValidateEventMessage < MessageQ::BaseMessage 
  attr_accessor :some_field
  def initialize(attrs={})
    attrs = attrs.symbolize_keys!
    @some_field = attrs[:some_field]
    super(attrs)
  end
end

class GoodMessageConsumer < MessageQ::Consumer
  from_queue 'a-queue'
  message_class SomeCoolEventMessage
  def process_message
    GoodModel.new.do_something(message.to_hash)
  end
end

class NoProcessMethodConsumer < MessageQ::Consumer
  from_queue 'a-queue'
  message_class SomeCoolEventMessage
end

class NoMessageClassConsumer < MessageQ::Consumer
  from_queue 'a-queue'
  def process_message
    GoodModel.new.do_something(message.to_hash)
  end
end

