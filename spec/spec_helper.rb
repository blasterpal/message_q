$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../spec/support', __FILE__)

require 'faker'
require 'message_q'
require 'class_builder'
require 'message_contexts'
require 'mock_queue'

require 'test_klasses'
require 'classes/no_message_consumer'


