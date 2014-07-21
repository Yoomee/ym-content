class ContentBooleanInput < FormtasticBootstrap::Inputs::BooleanInput

  def wrapper_html_options
    super.tap do |options|
      options[:class] = options[:class].split << ["form-group"].join(" ")
    end
  end

end
