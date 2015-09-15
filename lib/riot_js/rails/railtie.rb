require 'rails/railtie'
require 'riot_js/rails/processors/processor'
require 'riot_js/rails/helper'

module RiotJs
  module Rails
    class Railtie < ::Rails::Railtie
      config.riot = ActiveSupport::OrderedOptions.new
      config.riot.node_paths = []

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

      config.after_initialize do |app|
        node_paths = ENV['NODE_PATH'].to_s.split(':')
        node_paths += app.config.riot.node_paths
        node_global_path = detect_node_global_path
        node_paths << node_global_path if node_global_path

        ENV['NODE_PATH'] = node_paths.join(':')
      end


      def detect_node_global_path
        prefix = `npm config get prefix`.to_s.chomp("\n")
        possible_paths = [ "#{prefix}/lib/node", "#{prefix}/lib/node_modules" ]

        possible_paths.each do |path|
          return path if File.directory?(path)
        end
        return
      end

    end
  end
end
