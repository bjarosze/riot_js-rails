module RiotJs
  module Rails
    class SprocketsProcessor
      def self.instance
        @instance ||= new
      end

      def self.call(input)
        instance.call(input)
      end

      def call(input)
        prepare(input)
        data = process

        @context.metadata.merge(data: data)
      end

      def self.register_self(app)
        app.assets.register_engine '.tag', self, mime_type: 'application/javascript'
        app.assets.register_engine '.tag.jade', self, mime_type: 'text/jade'
      end

      private

      def process
        raise 'Not implemented'
      end

      def prepare(input)
        @context = input[:environment].context_class.new(input)
        @filename = input[:filename]
        @data = input[:data]
      end

    end
  end
end
