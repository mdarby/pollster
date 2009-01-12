require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe <%= class_name %>sHelper do
  
  describe " -- add_option_link" do
    it "should provide a link that inserts a new option" do
      pending("This is passing, but needs RJS love")
      <%= object_name %> = mock_model(<%= class_name %>)
      
      page = mock(page, :insert_html => self)
      helper.should_receive(:link_to_function).with("some_name").and_return(page)
      
      helper.add_option_link(<%= object_name %>, "some_name")
    end
  end
  
end