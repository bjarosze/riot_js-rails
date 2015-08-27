require 'rails/railtie'
require 'riot_js/rails/processors/processor'
require 'riot_js/rails/helper'

module RiotJs
  module Rails
    class Railtie < ::Rails::Railtie
      initializer :setup_sprockets do |app|
        Processor.register_self app

        if defined?(::Haml)
          require 'tilt/haml'
          app.assets.register_engine '.haml', ::Tilt::HamlTemplate
        end
      end

      initializer :add_helpers do |app|
        helpers = %q{ include ::RiotJs::Rails::Helper }
        ::ActionView::Base.module_eval(helpers)
        ::Rails.application.assets.context_class.class_eval(helpers)
      end

    end
  end
end
