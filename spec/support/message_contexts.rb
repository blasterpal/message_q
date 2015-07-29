require 'spec_helper'
RSpec.shared_context "message_contexts" do 

    let(:uid) { '123123123' }
    let(:created_at_valid) { rand(2).seconds.ago.to_i.to_s }
    let(:created_at_stale) { (MessageQ::BaseMessage::DEFAULT_MAX_AGE * 2).seconds.ago }
    let(:some_field_val) { Faker::Lorem.words(2).join(' ') }

    let(:base_required_options) do
      {
        uid: uid,
        created_at: created_at_valid
      }
    end
    let(:klass_validate_not_impl) do 
      define_class(:SomeEvent,MessageQ::BaseMessage) do |queue_n|
        attr_accessor :some_field
        def initialize(attrs={})
          super(attrs)
        end
      end
    end
    let!(:valid_klass) do 
      define_class(:SomeEvent,MessageQ::BaseMessage) do |val|
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
    end
    let(:valid_message_hash) do 
      {:some_field=>some_field_val, :created_at=>"1234567890", :errors=>{}, :max_age=>3600, :status=>"new", :strict=>true, :uid=>"123"}
    end
    let(:valid_serialized_message) do 
      valid_message_hash.to_json
    end

end
