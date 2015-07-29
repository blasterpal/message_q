require 'sneakers'
require 'active_support/all'

module MessageQ
  class Consumer
    include ::Sneakers::Worker
    #from_queue needs to be implemented in subclass and can also include per consumer config
    #https://github.com/jondot/sneakers/wiki/Configuration#local-per-worker

    class_attribute :message_class
    attr_reader :message

    def initialize
      if self.message_class.nil?
        raise NotImplementedError.new('Must specify message class with using_message :some_class')
      end
    end

    def work(msg)
      sym_message = JSON.parse(msg, symbolize_names: true)
      @message = message_klass.new(sym_message)
      process_message
    end

    def process_message
      raise NotImplementedError
    end
    
    # using_message :some_class
    # also SomeClass is ok
    def self.using_message(klass)
      c = klass.to_s.classify
      self.message_class = c.to_s.safe_constantize
    end

  end
end
