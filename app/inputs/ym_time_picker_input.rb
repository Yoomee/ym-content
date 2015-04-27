class YmTimePickerInput < FormtasticBootstrap::Inputs::StringInput
  # Formtastic has a time picker but formtastic-bootstrap doesn't so
  # using string input for type 'time'
  def html_input_type
    "time"
  end

  def input_html_options
    super.merge(type: html_input_type)
  end
end