class PersonasInput < Formtastic::Inputs::CheckBoxesInput
    def to_html
        input_wrapping do
          choices_wrapping do
            legend_html <<
            hidden_field_for_all <<
            choices_group_wrapping do
              collection.map { |choice|
                choice_wrapping(choice_wrapping_html_options(choice)) do
                  choice_html(choice)
                end
              }.join("\n").html_safe
            end
          end
        end
      end

  def choice_html(choice)
    template.content_tag(
    :label,
    checkbox_input(choice) + choice_label(choice) + template.image_tag(choice.image_uid),
    label_html_options.merge(:for => choice_input_dom_id(choice), :class => nil) 
    )
  end

  end

