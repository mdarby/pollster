require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PollVote do
  
  before do
    @vote = Factory(:poll_vote)
  end
  
  it "should be valid" do
    @vote.valid?.should be_true
  end
  
  it "should know about the User" do
    @vote.should respond_to(:user)
  end
  
  it "should know about the Poll" do
    @vote.should respond_to(:poll)
  end
  
end
