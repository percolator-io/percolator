class TagsInput < SimpleForm::Inputs::Base

  def input
    @builder.text_field(attribute_name, input_html_options.merge(value: object.send(attribute_name).join(',')))
  end

end