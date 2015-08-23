require 'rails/railtie'
require 'riot_js/rails/processors/processor'


module RiotJs
  module Rails
    class Railtie < ::Rails::Railtie
      initializer :setup_sprockets do |app|
        app.assets.register_engine '.tag', Processor, mime_type: 'application/javascript'

        if defined?(::Haml)
          require 'tilt/haml'
          app.assets.register_engine '.haml', ::Tilt::HamlTemplate, mime_type: 'text/html'
        end
      end
    end
  end
end