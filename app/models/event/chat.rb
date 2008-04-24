require 'models/event'
class Event < ActiveRecord::Base
  # a message was added to the chat room
  class Chat < Event
  end
end
