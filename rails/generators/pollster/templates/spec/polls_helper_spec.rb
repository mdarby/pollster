require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PollsHelper do
  
  describe " -- add_option_link" do
    it "should provide a link that inserts a new option" do
      pending("This is passing, but needs RJS love")
      poll = Factory(:poll)
      
      page = mock(page, :insert_html => self)
      helper.should_receive(:link_to_function).with("some_name").and_return(page)
      
      helper.add_option_link(poll, "some_name")
    end
  end
  
end