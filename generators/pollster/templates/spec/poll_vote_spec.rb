require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe <%= class_name %>Vote do
  
  before do
    @vote = <%= class_name %>Vote.new(:user_id => 1, :<%= object_name %>_id => 1)
  end
  
  it "should be valid" do
    @vote.valid?.should be_true
  end
  
  it "should know about the User" do
    @vote.should respond_to(:user)
  end
  
  it "should know about the <%= class_name %>" do
    @vote.should respond_to(:<%= object_name %>)
  end
  
end
