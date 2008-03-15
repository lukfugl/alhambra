require 'application'

module Hydra
  class << self
    def map
      yield self
    end

    def method_missing(method, *args, &block)
      super unless true # TODO: put in real condition 

      resource_name = method.to_s
      url_template = args.first
      controller = (resource_name + "_controller").camelize.constantize

      resource_methods = controller.instance_methods &
        [ "get", "post", "put", "delete", "options" ]

      resource_methods.each do |method|
        ActionController::Routing::Routes.add_named_route(
          resource_name,
          url_template,
          :controller => resource_name,
          :action => method,
          :conditions => { :method => method.to_sym }
        )
      end
    end
  end
end
