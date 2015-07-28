require 'spec_helper'
require 'class_builder'

RSpec.describe "MessageQ::BaseMessage" do 
  include ClassBuilder

  let(:uid) { '123123123' }
  let(:created_at_valid) { rand(2).seconds.ago.to_i.to_s }
  let(:created_at_stale) { (MessageQ::BaseMessage::DEFAULT_MAX_AGE * 2).seconds.ago }

  let(:base_required_options) do
    {
      uid: uid,
      created_at: created_at_valid
    }
  end

  #let(:queue_name) { 'eventmanager.the-message' }

  let(:klass_validate_not_impl) do 
    define_class(:SomeEvent,MessageQ::BaseMessage) do |queue_n|
      #set_queue queue_n
      attr_accessor :some_field
      def initialize(attrs={})
        super(attrs)
      end
    end
  end
  let(:valid_klass) do 
    define_class(:SomeEvent,MessageQ::BaseMessage) do |val|
      #set_queue queue_n
      attr_accessor :some_field
      def initialize(attrs={})
        super(attrs)
      end
      def validate
        errors.add(:some_field, 'has a problemo') if self.some_field.blank?
      end
    end
  end

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
  end


  #context "creating new message class" do
  ##subject { klass }

  #context "when initialized" do
  #let(:new_message) { klass.new(base_required_options.merge!(required_property1: required_property1)){queue_name} }

  #it "should set queue accessor" do
  #expect(new_message.queue).to eq(queue_name)
  ##new_message.required_property1)
  #end
  #end
  #end
end
