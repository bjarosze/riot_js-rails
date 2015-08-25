module RiotJs
  module Rails
    module Helper

      def riot_component(*args, &block)
        if args[1].kind_of?(Hash)
          custom_tag_riot_component(*args, &block)
        else
          html_tag_riot_component(*args, &block)
        end
      end

      private

      def custom_tag_riot_component(name, data, attributes={}, &block)
        component_name, attributes = component_attributes(name, data, attributes)

        component_tag(component_name, attributes, &block)
      end

      def html_tag_riot_component(tag, name, data, attributes={}, &block)
        component_name, attributes = component_attributes(name, data, attributes)
        attributes['riot-tag'] = component_name

        component_tag(tag, attributes, &block)
      end

      def component_attributes(name, data, attributes)
        component_name = name.to_s.gsub('_', '-')
        attributes_data = attributes[:data] || attributes['data'] || {}
        attributes_class = attributes[:class] || attributes['class']
        attributes = attributes.merge(id: "riot-#{component_name}-#{Random.rand(10000000)}",
                                      class: "#{attributes_class} riot-rails-component".strip,
                                      data: attributes_data.merge(opts: data.to_json))
        return component_name, attributes
      end

      def component_tag(tag_name, attributes, &block)
        if block_given?
          content_tag(tag_name, attributes, &block)
        else
          content_tag(tag_name, attributes) {}
        end
      end

    end
  end
end
