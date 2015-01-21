module SirTrevor::ViewHelper
  # Methods to help render sir trevor HTML in views
    def sir_trevor_markdown(text)
        renderer = Redcarpet::Render::HTML.new(:hard_wrap => true, :filter_html => false,
                                               :autolink => true, :no_intraemphasis => true,
                                               :fenced_code => true)
        markdown = Redcarpet::Markdown.new(renderer)
        markdown.render(text).html_safe
    end

    def sir_trevor_image_tag(block, image_type)
      # Does the image type exist on the block?
      if(block[:file].present?)

        image = block[:file]

        image_url = image[:url]
        width = image[:width] if image[:width].present?
        height = image[:height] if image[:height].present?

        options = {
          :class => "sir-trevor-image #{image_type}",
          :alt => block[:description]
        }

        options.merge!({ :width => width }) unless width.nil?
        options.merge!({ :height => height }) unless height.nil?

        image_tag(image_url, options) unless image_url.nil?
      end
    end
end


