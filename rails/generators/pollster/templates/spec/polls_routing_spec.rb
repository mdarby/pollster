require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PollsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "polls", :action => "index").should == "/polls"
    end
  
    it "should map #new" do
      route_for(:controller => "polls", :action => "new").should == "/polls/new"
    end
  
    it "should map #show" do
      route_for(:controller => "polls", :action => "show", :id => 1).should == "/polls/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "polls", :action => "edit", :id => 1).should == "/polls/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "polls", :action => "update", :id => 1).should == "/polls/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "polls", :action => "destroy", :id => 1).should == "/polls/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/polls").should == {:controller => "polls", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/polls/new").should == {:controller => "polls", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/polls").should == {:controller => "polls", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/polls/1").should == {:controller => "polls", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/polls/1/edit").should == {:controller => "polls", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/polls/1").should == {:controller => "polls", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/polls/1").should == {:controller => "polls", :action => "destroy", :id => "1"}
    end
  end
end
