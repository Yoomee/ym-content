class RichRedactorInput < FormtasticBootstrap::Inputs::TextInput
    def input_html_options
      super.merge(:class => "rich-redactor")
    end
end