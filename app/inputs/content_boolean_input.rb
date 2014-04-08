class ContentBooleanInput < FormtasticBootstrap::Inputs::BooleanInput

  def wrapper_html_options
    super.tap do |options|
      options[:class] = options[:class].split << ["form-group", "content-boolean"].join(" ")
    end
  end

  def to_html
    checkbox_wrapping do
      hidden_field_html <<
        checkbox_title <<
      template.content_tag(:div) do
        [label_with_nested_checkbox].join("\n").html_safe
      end
    end
  end

  def checkbox_title
    template.content_tag(:label, label_text)
  end

  def label_with_nested_checkbox
    builder.label(
      method,
      label_text_with_embedded_checkbox,
      label_html_options
    )
  end

  def label_text_with_embedded_checkbox
    check_box_html << "" << hint_text
  end

end
