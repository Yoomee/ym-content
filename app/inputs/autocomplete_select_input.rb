class AutocompleteSelectInput < FormtasticBootstrap::Inputs::SelectInput
    def input_html_options
      super.merge(:class => "autocomplete-select")
    end
end