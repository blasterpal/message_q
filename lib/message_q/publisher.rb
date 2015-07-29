module MessageQ
  class Publisher
    def self.publish!(msg,routing_key,options={})
      raise StandardError.new('Not MessageQ object') unless msg.kind_of? MessageQ::BaseMessage
      Sneakers::Publisher.new.publish(msg,{routing_key: routing_key}.merge!(options))
    end
  end
end
