# PORO that does 'work' after message is processed and delegated.
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

class AnotherCoolEventMessage < MessageQ::BaseMessage 
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
  using_message :some_cool_event_message
  def process_message
    GoodModel.new.do_something(message.to_hash)
  end
end

class AnotherMessageConsumer < MessageQ::Consumer
  from_queue 'a-queue'
  using_message AnotherCoolEventMessage
  def process_message
    GoodModel.new.do_something(message.to_hash)
  end
end

class NoProcessMethodConsumer < MessageQ::Consumer
  from_queue 'a-queue'
  using_message AnotherCoolEventMessage
end

class NoMessageConsumer < MessageQ::Consumer
  from_queue 'a-queue'
  def process_message
    GoodModel.new.do_something(message.to_hash)
  end
end


