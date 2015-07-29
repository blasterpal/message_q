require 'securerandom'

module MessageQ
  class BaseMessage
    class MessageFieldTypeError < StandardError;end

    attr_reader :errors
    
    # required
    attr_accessor :created_at #integer for epoch(seconds), pop and convert to DateTime
    attr_accessor :max_age #integer 
    attr_accessor :uid #string

    attr_accessor :status #string 

    DEFAULT_MAX_AGE = 3600

    # need validations?

    def initialize(attrs={})
      attrs = attrs.symbolize_keys!

      @created_at         = attrs[:created_at]
      @errors             = Errors.new
      @max_age            = (attrs[:max_age] && attrs[:max_age].to_i) || DEFAULT_MAX_AGE
      @status             = attrs[:status] || 'new' #add a struct later on
      @strict             = attrs[:strict].nil? ? true : attrs[:strict]
      @uid                = attrs[:uid]
      
      if @strict
        validate!
      end
      check_meta
    end

    def to_hash
      h = instance_variables.map do |var|
        [var[1..-1].to_sym, instance_variable_get(var)]
      end.to_h
      h[:errors] = self.errors.messages
      h
    end
    
    # override to_json on subclass as necc
    def serialize
      self.to_hash.to_json
    end

    def validate!
      validate
      unless errors.empty?
        raise MessageFieldTypeError.new("Errors: #{errors.messages}")
      end
    end

    def valid?
      self.errors.empty?
    end

    def validate
      raise NotImplementedError.new("A validate! method must be implemented on subclasses. Use errors.add(some_error: 'error detail') for your requirements.")
    end

    def check_meta
      errors.add(:created_at, "Not convertable to DateTime or too old") unless self.is_datetime?(self.created_at)
      #errors.add(created_at: "Stale message, older than #{self.max_age} seconds") unless !self.is_datetime?(self.created_at) && self.created_at > DEFAULT_MAX_AGE.seconds.ago
      errors.add(:uid, "UID must be present") if self.uid.blank?
    end

    def is_datetime?(dt)
      begin
        DateTime.strptime(dt.to_s,'%s') 
      rescue ArgumentError
        false
      end
    end
  end
end
