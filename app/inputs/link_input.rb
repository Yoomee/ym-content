class LinkInput < FormtasticBootstrap::Inputs::StringInput

  def to_html
    bootstrap_wrapping do
      builder.text_field(method, form_control_input_html_options.reverse_merge(:value => builder.object.send(method).try(:url)).merge(:id => "content_package_#{method}_url"))
    end
  end

end