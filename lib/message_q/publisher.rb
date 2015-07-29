require 'sneakers'
module MessageQ
  class Publisher
    def self.publish!(message,queue,options={})
      raise StandardError.new('Not MessageQ object') unless message.kind_of? MessageQ::BaseMessage

      queue = queue.to_s
      message_serialized = message.serialize

      raise StandardError.new('queue is missing or invalid') if queue.blank?

      all_options = {routing_key: queue}.merge!(options) #further extract into adapter later
      queue_handler(queue_adapter,message_serialized,all_options)
    end

    def self.queue_adapter
      Sneakers::Publisher.new
    end

    def self.queue_handler(adapter,msg,options={})
      adapter.publish(msg,options)
    end
  end
end
