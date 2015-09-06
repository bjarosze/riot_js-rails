require 'riot_js/rails/processors/compiler'
require 'riot_js/rails/processors/jade_compiler'

if Gem::Version.new(Sprockets::VERSION) < Gem::Version.new('3.0.0')
  require 'riot_js/rails/processors/sprockets_processor_v2'
else
  require 'riot_js/rails/processors/sprockets_processor_v3'
end

module RiotJs
  module Rails
    class Processor < SprocketsProcessor

      def process
        @data = compile_jade if @filename.ends_with? '.jade'
        compile_tag
      end

      private

      def compile_jade
        ::RiotJs::Rails::JadeCompiler.compile @data
      end

      def compile_tag
        ::RiotJs::Rails::Compiler.compile(@data)
      end
    end
  end
end
