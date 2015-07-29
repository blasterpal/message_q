module MessageQ
  class Consumer
    include Sneakers::Worker
    #from_queue needs to be implemented in subclass
    
    def initialize
      # class eval and create methods? (send is slower)
    end

    def work(msg)
      symbolized_message = JSON.parse(message, symbolize_names: true)
      msg = @@message_klass.new(symbolized_message)
      process_message(msg)
    end

    def process_message(msg)
      raise NotImplementedError
    end

    # message_class DeliverReport
    def self.message_class(klass_name)
      @@message_klass
    end

  end
end
