require 'spec_helper'

RSpec.describe "MessageQ::Consumer" do 
  include ClassBuilder
  include_context "message_contexts"

  let(:message_klass) { GoodMessageConsumer }
  let(:consume) do 
    message_klass.new.work(message_to_consume)
  end
  let(:message_to_consume) { valid_serialized_message }

  context "consuming messages" do
    context "using message class" do
      it "should build message accessor" do
        expect_any_instance_of(GoodModel).to receive(:do_something).with(valid_message_hash)
        consume 
      end
    end

    context "process_message implemented in consumer subclass" do
      it "should call method and return result" do 
        expect(consume).to eq(some_field_val.upcase)
      end
    end
  end

  context "invalid class and errors" do
    let(:message_klass) { NoProcessMethodConsumer }
    context "process_message not implemented" do
      it "should raise error" do
        expect{consume}.to raise_error
      end
    end

    context "message_class not called" do
      let(:message_klass) { NoMessageClassConsumer }
      it "should raise error" do 
        expect{consume}.to raise_error
      end
    end
  end
end
