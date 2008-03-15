require File.dirname(__FILE__) + '/spec_helper'

def open_session
  session = ActionController::Integration::Session.new
  yield session if block_given?
  session
end
