require 'sneakers'

module MessageQ
  class Consumer
    include ::Sneakers::Worker
    #from_queue needs to be implemented in subclass and can also include per consumer config
    #https://github.com/jondot/sneakers/wiki/Configuration#local-per-worker
    
    attr_reader :message 
    def initialize
      # class eval and create methods? (send is slower)
    end

    def work(msg)
      sym_message = JSON.parse(msg, symbolize_names: true)
      @message = @@message_klass.new(sym_message)
      process_message
    end

    def process_message
      raise NotImplementedError
    end

    # message_class DeliverReport
    def self.message_class(klass_name)
      @@message_klass = klass_name
    end

  end
end
