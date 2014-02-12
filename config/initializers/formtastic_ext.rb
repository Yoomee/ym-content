module Formtastic
  module Helpers
    module InputHelper

      def content_input(content_attribute, options = {})
        options.reverse_merge!(
          :as => content_attribute.field_type == 'text' ? 'redactor' : content_attribute.field_type,
          :label => content_attribute.name,
          :hint => content_attribute.description,
          :required => content_attribute.required
        )
        input(content_attribute.slug, options)
      end

    end
  end
end
