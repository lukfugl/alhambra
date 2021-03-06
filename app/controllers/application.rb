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

  def REST
    method = request.method.to_s.upcase
    if self.respond_to?(method)
      self.send(method)
    else
      allow = [ 'HEAD', 'GET', 'POST', 'PUT', 'DELETE' ].
        select{ |name| respond_to?(name) }
      head :status => :method_not_allowed, :allow => allow
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

    if event_data && event_data['seat']
      event_data['seat'] = instantiate_url(event_data['seat'])
    end

    event = event_type.create(event_data)
    raise BadRequest unless event

    return event

  rescue Event::IncompleteEvent
    raise BadRequest
  end

  private

  def event_uri(event)
    "TODO"
  end

  def instantiate_url(url)
    case url
    when %r{game/\d+/seats/(\d+)}
      Seat.find($1.to_i)
    end
  end
end
