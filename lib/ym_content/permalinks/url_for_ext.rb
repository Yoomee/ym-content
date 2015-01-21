module ActionDispatch
  module Routing
    module UrlFor

      def url_for_with_permalinks(options = nil)
        permalink = extract_permalink(options)
        url = url_for_without_permalinks(options)
        if permalink && !permalink.changed?
          url.sub(permalink.resource_path, YmContent.config.nested_permalinks ? permalink.full_path : "/#{permalink.path}")
        else
          url
        end
      end
      alias_method_chain :url_for, :permalinks

      private
      def extract_permalink(options)
        case options
        when Hash
          return nil if options.delete(:permalink) == false
          if options[:controller] && options[:id]
            return Permalink.find_by_resource_type_and_resource_id(options[:controller].classify, options[:id])
          elsif options[:_positional_args]
            resource = options[:_positional_args].first
            if resource.respond_to?(:permalink) && resource.permalink
              return resource.permalink
            end
          end
        else
          if options.respond_to?(:permalink)
            return options.permalink
          end
        end
        nil
      end

    end
  end
end