class Errors
  # rip off of ActiveModel Errors
  attr_accessor :errors
  def initialize
    @errors = {}
  end
  def add(name,message='is invalid')
    @errors.store(name.to_sym,message)
    messages
  end
  def empty?
    @errors.blank?
  end
  def messages
    @errors
  end
end
