module RiotJs
  module Rails
    module Helper

      def riot_component(*args, &block)
        case args.count
          when 2
            custom_tag_riot_component(*args, &block)
          when 3
            html_tag_riot_component(*args, &block)
          else
            raise ArgumentError, 'wrong number of arguments (required 2 or 3)'
        end
      end

      private

      def custom_tag_riot_component(name, data, &block)
        component_name, attributes = component_attributes(name, data)

        component_tag(component_name, attributes, &block)
      end

      def html_tag_riot_component(tag, name, data, &block)
        component_name, attributes = component_attributes(name, data)
        attributes['riot-tag'] = component_name

        component_tag(tag, attributes, &block)
      end

      def component_attributes(name, data)
        component_name = name.to_s.gsub('_', '-')
        attributes = {
          id: "riot-#{component_name}-#{Random.rand(10000000)}",
          class: 'riot-rails-component',
          data: { opts: data.to_json }
        }
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
