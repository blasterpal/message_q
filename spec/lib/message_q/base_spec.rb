require 'spec_helper'

RSpec.describe "MessageQ::BaseMessage" do
  include ClassBuilder
  include_context "message_contexts"


  context "validation and errors" do 
    context "creating new message class without validate method" do 
      it "should raise exception" do
        expect{klass_validate_not_impl.new(base_required_options)}.to raise_error
      end
    end
    context "validation of required fields" do
      it "should raise exception" do
        expect{klass_validate_not_impl.new(base_required_options)}.to raise_error
      end
      it "should have validation errors" do
        expect{valid_klass.new(base_required_options)}.to raise_error
      end
    end
  end

  context "validation" do 
    it "should raise exception with object errors" do
      expect{valid_klass.new(base_required_options.merge!)}.to raise_error
    end
    it "should have validation errors" do
        k = valid_klass.new(base_required_options.merge!(strict: false))
        expect(k.validate).to eq({:some_field => 'has a problemo'})
    end
    context "validation of base required fields" do
      it "should raise exception" do
        expect{klass_validate_not_impl.new({})}.to raise_error
      end
      it "should have validation errors" do
        k = valid_klass.new(strict: false)
        expect(k.validate).to eq(
          {
            :created_at=>"Not convertable to DateTime or too old",
            :uid=>"UID must be present",
            :some_field=>"has a problemo"}
        )
      end
    end
    context "serialization" do
      let(:message_hash) do 
        {:some_field=>"a nice value", :created_at=>"1234567890", :errors=>{}, :max_age=>3600, :status=>"new", :strict=>true, :uid=>"123"}
      end
      it "should have attributes in JSON" do
        msg = valid_klass.new(message_hash)
        expect(msg.serialize).to eq(message_hash.to_json)
      end
    end
  end
end
