module <%= class_name.pluralize %>Helper

  def add_option_link(<%= object_name %>, name)
    link_to_function name do |page|
      page.insert_html :bottom, :options, :partial => 'option_form', :locals => {:option => []}
    end
  end
  
  def display_graph(<%= object_name %>, options = {})
    size       = options.has_key?(:size) ? options[:size] : "350x150"
    base_color = options.has_key?(:base_color) ? options[:base_color] : "2F87ED"
    bg_color   = options.has_key?(:bg_color) ? options[:bg_color] : "EEEEEE"
    
    Gchart.pie_3d(
      :size       => size,
      :bar_colors => base_color,
      :bg         => bg_color,
      :legend     => <%= object_name %>.pie_legend,
      :data       => <%= object_name %>.current_results_percentages, 
      :format     => 'image_tag'
    )
  end

end