require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/polls/_final_results.html.haml" do
  
  before do
    @poll = Factory(:poll)
    @poll.stub!(:winner => "foo")
    @poll.stub!(:winners => ["foo", "bar"])
  end

  def do_get
    render :partial => "polls/final_results", :locals => {:poll => @poll}
  end


  describe " when a Poll ends in a tie" do
    before do
      @poll.stub!(:ends_in_tie? => true)
    end
    
    it "should show this blurb" do
      do_get
      response.should include_text "We have a tie between\n  <b>foo and bar!</b>"
    end
  end
  
  describe " when a Poll doesn't end in a tie" do
    before do
      @poll.stub!(:ends_in_tie? => false)
    end
    
    it "should show this blurb" do
      do_get
      response.should include_text "...and the winner is:\n  <b>foo!</b>"
    end
  end
  
end