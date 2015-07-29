require 'spec_helper'

RSpec.describe "MessageQ::Consumer" do 
  include ClassBuilder
  include_context "message_contexts"

  let!(:some_model) do 
    define_class(:CoolModel) do 
      def do_something(message)
        message[:some_field].upcase
      end
    end
  end
  let!(:some_consumer) do 
    define_class(:FooBarMessageConsumer,MessageQ::Consumer) do 
      from_queue 'a-nice-queue'
      message_class SomeEvent
      def process_message
        CoolModel.new.do_something(message.to_hash)
      end
    end
  end

  let(:consume) do 
    FooBarMessageConsumer.new.work(valid_serialized_message)
  end

  context "consuming messages" do
    context "using message class" do
      let(:message_klass) do 
        SomeEvent.new(valid_message_hash)
      end

      it "should build message accessor" do
        expect_any_instance_of(CoolModel).to receive(:do_something).with(message_klass.to_hash)
        consume 
      end
    end

    context "process_message" do
      it "should call method correctly" do 
        expect(consume).to eq(some_field_val.upcase)
      end
    end
  end

  context "invalid class and errors" do
    context "process_message not implemented"
    context "message_class not called"
  end
end
