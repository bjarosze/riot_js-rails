require 'rails/railtie'
require 'riot_js/rails/processors/processor'
require 'riot_js/rails/helper'

module RiotJs
  module Rails
    class Railtie < ::Rails::Railtie
      config.riot = ActiveSupport::OrderedOptions.new
      config.riot.node_paths = []

      initializer :setup_sprockets do |app|
        # app is a YourApp::Application
        # config is Rails::Railtie::Configuration that belongs to RiotJs::Rails::Railtie
        Processor.register_self app, config

        if defined?(::Haml)
          require 'tilt/haml'
          Haml::Template.options[:format] = :html5

          if config.respond_to?(:assets)
            config.assets.configure do |env|
              if env.respond_to?(:register_transformer)
                # Sprockets 3 and 4
                env.register_mime_type 'text/riot-tag+haml', extensions: ['.tag.haml'], charset: :html
                env.register_transformer 'text/riot-tag+haml', 'application/javascript',
                        Proc.new{ |input| Processor.call(::Haml::Engine.new(input[:data]).render) }
              elsif env.respond_to?(:register_engine)
                if Sprockets::VERSION.start_with?("3")
                  # Sprockets 3 ... is this needed?
                  env.register_engine '.haml', ::Tilt::HamlTemplate, { silence_deprecation: true }
                else
                  # Sprockets 2.12.4
                  env.register_engine '.haml', ::Tilt::HamlTemplate
                end
              end
            end
          else
            # Sprockets 2
            app.assets.register_engine '.haml', ::Tilt::HamlTemplate
          end
        end
      end

      initializer :add_helpers do |app|
        helpers = %q{ include ::RiotJs::Rails::Helper }
        ::ActionView::Base.module_eval(helpers)
        ::Rails.application.config.assets.context_class.class_eval(helpers)
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
