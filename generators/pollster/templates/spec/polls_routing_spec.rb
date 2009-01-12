require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe <%= class_name %>sController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "<%= object_name %>s", :action => "index").should == "/<%= object_name %>s"
    end
  
    it "should map #new" do
      route_for(:controller => "<%= object_name %>s", :action => "new").should == "/<%= object_name %>s/new"
    end
  
    it "should map #edit" do
      route_for(:controller => "<%= object_name %>s", :action => "edit", :id => 1).should == "/<%= object_name %>s/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "<%= object_name %>s", :action => "update", :id => 1).should == "/<%= object_name %>s/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "<%= object_name %>s", :action => "destroy", :id => 1).should == "/<%= object_name %>s/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/<%= object_name %>s").should == {:controller => "<%= object_name %>s", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/<%= object_name %>s/new").should == {:controller => "<%= object_name %>s", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/<%= object_name %>s").should == {:controller => "<%= object_name %>s", :action => "create"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/<%= object_name %>s/1/edit").should == {:controller => "<%= object_name %>s", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/<%= object_name %>s/1").should == {:controller => "<%= object_name %>s", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/<%= object_name %>s/1").should == {:controller => "<%= object_name %>s", :action => "destroy", :id => "1"}
    end
  end
end
