require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module <%= class_name %>Attributes
  def valid_attributes
    {
      :name          => "foo",
      :description   => "foo",
      :options       => ["first", "second", "third"],
      :ends_at       => Date.parse("2009-01-09"),
      :created_at    => Date.parse("2009-01-01"),
      :updated_at    => Date.parse("2009-01-01"),
      :created_by_id => 1
    }
  end
end

describe <%= class_name %>sHelper do
  
  include <%= class_name %>Attributes
  
  describe " -- add_option_link" do
    it "should provide a link that inserts a new option" do
      <%= object_name %> = mock_model(<%= class_name %>)
      
      page = mock(page, :insert_html => self)
      helper.should_receive(:link_to_function).with("some_name").and_return(page)
      
      helper.add_option_link(<%= object_name %>, "some_name")
    end
  end
  
  describe " -- display_graph" do
    before do
      @<%= object_name %> = <%= class_name %>.create!(valid_attributes)
    end
    
    describe " accepted parameters" do
      it "should accept a :size parameter" do
        helper.display_graph(@<%= object_name %>, :size => "100x150").should include_text 'width="100" height="150"'
      end
    
      it "should accept a :base_color parameter" do
        helper.display_graph(@<%= object_name %>, :base_color => "EFEFEF").should include_text 'chco=EFEFEF'
      end
    
      it "should accept a :bg_color parameter" do
        helper.display_graph(@<%= object_name %>, :bg_color => "AFAFAF").should include_text 'chf=bg,s,AFAFAF'
      end
    end
    
    describe " default parameters" do
      before do
        @<%= object_name %> = <%= class_name %>.create!(valid_attributes)
      end
      
      it "should accept a :size parameter" do
        helper.display_graph(@<%= object_name %>).should include_text 'width="350" height="150"'
      end
    
      it "should accept a :base_color parameter" do
        helper.display_graph(@<%= object_name %>).should include_text 'chco=2F87ED'
      end
    
      it "should accept a :bg_color parameter" do
        helper.display_graph(@<%= object_name %>).should include_text 'chf=bg,s,EEEEEE'
      end
    end
    
  end
  
end