require File.dirname(__FILE__) + '/../spec_helper'

describe PostsController do
  describe "route generation" do
  
    it "should map { :controller => 'hours_estimates', :action => 'new' } to /jobs/1/message_threads/1/posts/new" do
      route_for(:controller => "posts", :action => "new", :job_id => "1", :message_thread_id => "1").should == "/jobs/1/message_threads/1/posts/new"
    end
  
    it "should map { :controller => 'hours_estimates', :action => 'edit', :id => 1 } to /jobs/1/message_threads/1/posts/1/edit" do
      route_for(:controller => "posts", :action => "edit", :id => 1, :job_id => "1", :message_thread_id => "1").should == "/jobs/1/message_threads/1/posts/1/edit"
    end
  
    it "should map { :controller => 'hours_estimates', :action => 'update', :id => 1} to /jobs/1/message_threads/1/posts/1" do
      route_for(:controller => "posts", :action => "update", :id => 1, :job_id => "1", :message_thread_id => "1").should == "/jobs/1/message_threads/1/posts/1"
    end
  
    it "should map { :controller => 'hours_estimates', :action => 'destroy', :id => 1} to /jobs/1/message_threads/1/posts/1" do
      route_for(:controller => "posts", :action => "destroy", :id => 1, :job_id => "1", :message_thread_id => "1").should == "/jobs/1/message_threads/1/posts/1"
    end
  end

  describe "route recognition" do
  
    it "should generate params { :controller => 'hours_estimates', action => 'new' } from GET /jobs/1/message_threads/1/posts/new" do
      params_from(:get, "/jobs/1/message_threads/1/posts/new").should == {:controller => "posts", :action => "new", :job_id => "1", :message_thread_id => "1"}
    end
  
    it "should generate params { :controller => 'hours_estimates', action => 'create' } from POST /jobs/1/message_threads/1/posts" do
      params_from(:post, "/jobs/1/message_threads/1/posts").should == {:controller => "posts", :action => "create", :job_id => "1", :message_thread_id => "1"}
    end
  
    it "should generate params { :controller => 'hours_estimates', action => 'edit', id => '1' } from GET /jobs/1/message_threads/1/posts/1;edit" do
      params_from(:get, "/jobs/1/message_threads/1/posts/1/edit").should == {:controller => "posts", :action => "edit", :id => "1", :job_id => "1", :message_thread_id => "1"}
    end
  
    it "should generate params { :controller => 'hours_estimates', action => 'update', id => '1' } from PUT /jobs/1/message_threads/1/posts/1" do
      params_from(:put, "/jobs/1/message_threads/1/posts/1").should == {:controller => "posts", :action => "update", :id => "1", :job_id => "1", :message_thread_id => "1"}
    end
  
    it "should generate params { :controller => 'hours_estimates', action => 'destroy', id => '1' } from DELETE /jobs/1/message_threads/1/posts/1" do
      params_from(:delete, "/jobs/1/message_threads/1/posts/1").should == {:controller => "posts", :action => "destroy", :id => "1", :job_id => "1", :message_thread_id => "1"}
    end
  end
end