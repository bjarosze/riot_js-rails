module RiotJs
  module Rails
    class SprocketsProcessor < Tilt::Template

      self.default_mime_type = 'application/javascript'

      def self.register_self(app)
        app.assets.register_engine '.tag', self
      end

      def evaluate(context, locals, &block)
        @context = context
        process
      end

      def prepare
        @data = data
      end

      def process
        raise 'Not implemented'
      end

    end
  end
end
