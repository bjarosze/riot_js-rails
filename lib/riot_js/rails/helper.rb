module RiotJs
  module Rails
    module Helper

      def riot_component(name, options, &block)
        component_name = name.to_s.gsub('_', '-')
        attributes = { id: "riot-#{component_name}-#{Random.rand(10000000)}",
                       class: 'riot-rails-component',
                       data: { opts: options.to_json } }

        if block_given?
          content_tag(component_name, attributes, &block)
        else
          content_tag(component_name, attributes) {}
        end

      end

    end
  end
end