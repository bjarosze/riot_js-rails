require 'riot_js/rails/processors/compiler'

module RiotJs
  module Rails
    class Processor
      def self.instance
        @instance ||= new
      end

      def self.call(input)
        instance.call(input)
      end

      def call(input)
        prepare(input)

        data = compile_tag

        @context.metadata.merge(data: data)
      end

      private

      def prepare(input)
        @context = input[:environment].context_class.new(input)
        @data = input[:data]
      end

      def compile_tag
        ::RiotJs::Rails::Compiler.compile(@data)
      end
    end
  end
end