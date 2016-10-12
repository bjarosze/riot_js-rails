require 'riot_js/rails/processors/compiler'

module RiotJs
  module Rails

    # Sprockets 2, 3 & 4 interface
    class SprocketsExtensionBase
      attr_reader :default_mime_type

      def initialize(filename, &block)
        @filename = filename
        @source   = block.call
      end

      def render(context, empty_hash_wtf)
        self.class.run(@filename, @source, context)
      end

      def self.run(filename, source, context)
        raise 'Not implemented'
      end

      def self.call(input)
        if input.is_a?(String)
          run("", input, nil)
        else
          filename = input[:filename]
          source   = input[:data]
          context  = input[:environment].context_class.new(input)

          result = run(filename, source, context)
          context.metadata.merge(data: result)
        end
      end

      private

      def self.register_self_helper(app, config, file_ext, mime_type_from, mime_type_to, charset=nil)

        if config.respond_to?(:assets)
          config.assets.configure do |env|
            if env.respond_to?(:register_transformer)
              # Sprockets 3 and 4
              env.register_mime_type mime_type_from, extensions: [file_ext], charset: charset
              env.register_transformer mime_type_from, mime_type_to, self
            elsif env.respond_to?(:register_engine)
              if Sprockets::VERSION.start_with?("3")
                # Sprockets 3 ... is this needed?
                env.register_engine file_ext, self, { mime_type: mime_type_to, silence_deprecation: true }
              else
                # Sprockets 2.12.4
                @default_mime_type = mime_type_to
                env.register_engine file_ext, self
              end
            end
          end
        else
          # Sprockets 2.2.3
          @default_mime_type = mime_type_to
          app.assets.register_engine file_ext, self
        end
      end

    end

    class Processor < SprocketsExtensionBase

      def self.run(filename, source, context)
        ::RiotJs::Rails::Compiler.compile(source)
      end

      def self.register_self(app, config)
        # app is a YourApp::Application
        # config is Rails::Railtie::Configuration that belongs to RiotJs::Rails::Railtie
        register_self_helper(app, config, '.tag', 'text/riot-tag', 'application/javascript', :html)
      end

    end
  end
end
