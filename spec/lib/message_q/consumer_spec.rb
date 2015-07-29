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
  let(:consumer_klass) do 
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
        valid_message_klass
        SomeEvent.new(valid_message_hash)
      end

      it "should build message accessor" do
        valid_message_klass
        consumer_klass
        expect_any_instance_of(CoolModel).to receive(:do_something).with(message_klass.to_hash)
        consume 
      end
    end

    context "process_message implemented in consumer subclass" do
      it "should call method and return result" do 
        valid_message_klass
        consumer_klass
        expect(consume).to eq(some_field_val.upcase)
      end
    end
  end

  context "invalid class and errors" do
    context "process_message not implemented" do
      let!(:consumer_klass) do 
        valid_message_klass
        define_class(:BarFooMessageConsumer,MessageQ::Consumer) do 
          from_queue 'a-nice-queue'
          message_class SomeEvent
        end
      end
      it "should raise error" do
        expect{BarFooMessageConsumer.new.work(valid_serialized_message)}.to raise_error
      end
    end

    context "message_class not called" do
      let!(:consumer_klass) do 
        valid_message_klass
        define_class(:BarBazFooMessageConsumer,MessageQ::Consumer) do 
          from_queue 'a-nice-queue'
          def process_message
            CoolModel.new.do_something(message.to_hash)
          end
        end
      end
      it "should raise error" do 
        expect{BarBazFooMessageConsumer.new.work(valid_serialized_message)}.to raise_error
      end
    end
  end
end
