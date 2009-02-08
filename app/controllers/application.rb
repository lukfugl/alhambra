# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '83362e6bdd4d18b7c1e424c35e25ec19'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  def method_missing(name, *args, &blk)
    if [ 'GET', 'POST', 'PUT', 'DELETE' ].include?(name.to_s.upcase)
      allow = [ 'GET', 'POST', 'PUT', 'DELETE' ].
        select{ |name| respond_to?(name) }.
        map{ |name| name.to_s.upcase }
      head :status => :method_not_allowed, :allow => allow
    else
      super(name, *args, &blk)
    end
  end

  private

  class BadRequest < RuntimeError; end

  def handle_posted_event(*valid_events)
    event_data = YAML::load(request.body.read)

    raise BadRequest unless
      event_data.kind_of?(Hash) &&
      event_data.keys.size == 1

    event_type = event_data.keys.first
    event_data = event_data[event_type]
    event_type = "Event::#{event_type}".constantize
    raise BadRequest unless event_type
    raise BadRequest unless valid_events.include?(event_type)

    event = event_type.create(event_data)
    raise BadRequest unless event

    return event

  rescue Event::IncompleteEvent
    raise BadRequest
  end

  def event_uri(event)
    "TODO"
  end
end
