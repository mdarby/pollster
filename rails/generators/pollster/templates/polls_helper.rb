module <%= class_name.pluralize %>Helper

  def add_option_link(<%= object_name %>, name)
    link_to_function name do |page|
      page.insert_html :bottom, :options, :partial => 'option_form', :locals => {:option => []}
    end
  end

end