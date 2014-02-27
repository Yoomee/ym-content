module Formtastic
  module Helpers
    module InputHelper

      def content_input(content_attribute, options = {})
        method = content_attribute.slug
        method += "_url" if content_attribute.field_type.embeddable?
        options.reverse_merge!(
          :as => content_attribute.input_type,
          :label => content_attribute.name,
          :hint => content_attribute.description,
          :required => content_attribute.required
        )
        input(method, options)
      end

    end
  end
end
