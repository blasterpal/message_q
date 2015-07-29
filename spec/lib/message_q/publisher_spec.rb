require 'spec_helper'

RSpec.describe "MessageQ::Publisher" do 
  include ClassBuilder
  include_context "message_contexts"
  include MockQueue

  let(:message_klass) { SomeCoolEventMessage }
  let(:message_klass_instance) { message_klass.new(message_klass_options) }
  let(:message_to_consume) { valid_serialized_message }
  let(:message_klass_options) do 
    base_required_options.merge!({
      some_field: some_field_val,
      strict: true
    })
  end

  let(:publisher) { MessageQ::Publisher }
  let(:publish_adapter) { Sneakers::Publisher} 
  let(:queue) { 'service.queue1' }
  let(:publish_options) do
    {routing_key: queue}
  end
  let(:publish_arguments) do
    [message_klass_instance,queue, publish_options]
  end
  let(:publish) do 
    publisher.publish!(*publish_arguments)
  end
  let(:double_queue_adapter) do 
    double("Sneakers::Publisher").as_null_object
  end


  context "publish!" do
    context "when arguments are valid" do
      it "should publish" do
        expect(MessageQ::Publisher).to receive(:queue_adapter).and_return(double_queue_adapter)
        expect(double_queue_adapter).to receive(:publish).with(message_klass_instance.serialize,publish_options)
        publish
      end
    end
    context "when arguments are invalid" do 
      let(:publish_arguments) do 
        [Object.new,'',{}]
      end
      xit "should raise error" do
        expect{publish}.to raise_error
      end
    end

  end

end
