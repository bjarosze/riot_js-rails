require 'action_view'
require 'execjs'

module RiotJs
  module Rails
    class Compiler
      include ::ActionView::Helpers::JavaScriptHelper

      JS_RUNTIME = ::ExecJS::ExternalRuntime.new(
          name: 'Node.js (V8)',
          command: ['nodejs', 'node'],
          encoding: 'UTF-8',
          runner_path: File.expand_path('../../../../../vendor/assets/javascripts/compiler/node_runner.js', __FILE__),
      )
      JS_RUNTIME.instance_variable_set :@binary, JS_RUNTIME.send(:locate_binary) if defined?(::Barista)

      RIOT_COMPILER_PATH = File.expand_path('../../../../../vendor/assets/javascripts/compiler/compiler.js', __FILE__)

      def self.instance
        @@instance ||= new
      end

      def self.compile(tag_source)
        instance.compile(tag_source)
      end

      def compile(tag_source)
        compiler_source = <<-JS
          var compiler = require("#{RIOT_COMPILER_PATH}");
          return compiler.compile("#{escape_javascript(tag_source)}");
        JS

        JS_RUNTIME.exec(compiler_source)
      end

    end
  end
end
