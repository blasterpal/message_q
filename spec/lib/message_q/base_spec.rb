require 'spec_helper'

RSpec.describe "MessageQ::BaseMessage" do
  include ClassBuilder
  include_context "message_contexts"

  let(:message_klass) { SomeCoolEventMessage }
  let(:consume) do 
    message_klass_instance.work(message_to_consume)
  end
  let(:message_klass_instance) { message_klass.new(message_klass_options) }
  let(:message_to_consume) { valid_serialized_message }
  let(:message_klass_options) do 
    base_required_options.merge!({
      some_field: some_field_val,
      strict: true
    })
  end

  # TODO
  context "valid object initialization" do
  end

  context "validation and errors" do 
    context "creating new message class without validate method" do 
      let(:message_klass) { NoValidateEventMessage }
      it "should raise exception" do
        expect{message_klass_instance}.to raise_error
      end
    end
    context "validation" do 
      context "strict" do
        let(:message_klass_options) do 
          base_required_options.merge!({})
        end
        it "should raise exception with object errors" do
          expect{message_klass_instance}.to raise_error
        end
        context "validation of base required fields" do
          it "should raise exception" do
            expect{message_klass.new({})}.to raise_error
          end
        end
      end
      context "strict is false" do 
        let(:message_klass_options) do 
          base_required_options.merge!({
            strict: false
          })
        end
        context "missing option for class" do
          it "should have validation errors" do
            expect(message_klass_instance.validate).to eq({:some_field => 'has a problemo'})
          end
        end
        context "missing base and class options" do
          let(:message_klass_options) do 
            {
              strict: false
            }
          end
          it "should have validation errors" do
            expect(message_klass_instance.validate).to eq(
              {
                :created_at=>"Not convertable to DateTime or too old",
                :uid=>"UID must be present",
                :some_field=>"has a problemo"}
            )
          end
        end
      end
    end

    context "serialization" do
      let(:message_klass_options) { valid_message_hash }
      it "should have attributes in JSON" do
        expect(message_klass_instance.serialize).to eq(valid_message_hash.to_json)
      end
    end
  end
end
