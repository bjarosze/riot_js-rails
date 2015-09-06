require 'execjs'

module RiotJs
  module Rails
    class JadeCompiler
      extend ::ActionView::Helpers::JavaScriptHelper

      ASSETS_PATH = File.expand_path '../../../../../vendor/assets/javascripts', __FILE__
      JADE_PATH = "#{ASSETS_PATH}/compiler/jade.js"

      RUNTIME = ::ExecJS.compile <<-JS
        var window = {};
        #{File.read JADE_PATH}
        var jade = window.jade;
      JS

      def self.compile jade_source
        return RUNTIME.exec <<-JS
          return jade.render("#{escape_javascript jade_source}")
        JS
      end

    end
  end
end
