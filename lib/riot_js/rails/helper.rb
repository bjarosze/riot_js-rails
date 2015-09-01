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
        riot_data = { opts: data.to_json, riot: true }
        attributes = attributes.merge(data: attributes_data.merge(riot_data))
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
