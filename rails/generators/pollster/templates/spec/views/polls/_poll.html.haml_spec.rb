require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/polls/_poll.html.haml" do
  
  before do
    @poll = Factory(:poll)
  end

  def do_get
    render :partial => "polls/poll", :locals => {:poll => @poll}
  end


  it "should render inside a div.block" do
    do_get
    response.should have_tag("div[class=?]", "block")
  end
  
  it "should show the name" do
    do_get
    response.should include_text @poll.name
  end
  
  it "should show when it ends" do
    do_get
    response.should include_text @poll.ends_at.to_s
  end

  it "should show the description" do
    do_get
    response.should include_text @poll.description
  end

  
  describe " when a vote can be cast" do
    before do
      @poll.stub!(:can_by_voted_on_by => true)
    end
    
    it "should have a #cast_vote_div" do
      do_get
      response.should have_tag("div[id=?]", "cast_vote_div")
    end
    
    it "should render the vote partial" do
      template.should_receive(:render).with(:partial => "vote", :locals => {:poll => @poll})
      do_get
    end
    
  end
  
  describe " when a vote can not be cast" do
    before do
      @poll.stub!(:can_by_voted_on_by => false)
    end
    
    it "should not have a #cast_vote_div" do
      do_get
      response.should_not have_tag("div[id=?]", "cast_vote_div")
    end
    
    it "should not render the vote partial" do
      template.should_not_receive(:render).with(:partial => "vote", :locals => {:poll => @poll})
      do_get
    end
    
  end
  
  describe " when the current user has already voted" do
    before do
      @poll.stub!(:has_already_voted? => true)
    end
    
    it "should have a #current_results_div" do
      do_get
      response.should have_tag("div[id=?]", "current_results_div")
    end
    
    it "should render the current_results partial" do
      template.should_receive(:render).with(:partial => "current_results", :locals => {:poll => @poll})
      do_get
    end
    
  end
  
  describe " when the current user has already voted" do
    before do
      @poll.stub!(:has_already_voted? => false)
    end
    
    it "should not have a #current_results_div" do
      do_get
      response.should_not have_tag("div[id=?]", "current_results_div")
    end
    
    it "should not render the current_results partial" do
      template.should_not_receive(:render).with(:partial => "current_results", :locals => {:poll => @poll})
      do_get
    end
    
  end
  
  describe " when the Poll can be edited" do
    it "should show an edit link" do
      template.stub!(:updatable => true)
      do_get
      response.should have_tag("a[href=?]", edit_poll_path(@poll))
    end
  end
  
  describe " when the Poll can not be edited" do
    it "should not show an edit link" do
      template.stub!(:updatable => false)
      do_get
      response.should_not have_tag("a[href=?]", edit_poll_path(@poll))
    end
  end
  
  describe " when the Poll can be deleted" do
    it "should show a delete link" do
      template.stub!(:deletable => true)
      do_get
      response.should have_tag("a[href=?][onclick=?]", poll_path(@poll), /.*delete.*/)
    end
  end
  
  describe " when the Poll can not be deleted" do
    it "should not show an delete link" do
      template.stub!(:deletable => false)
      do_get
      response.should_not have_tag("a[href=?][onclick=?]", poll_path(@poll), /.*delete.*/)
    end
  end
  
  describe " when the Poll is over" do
    before do
      @poll.stub!(:active? => false)
    end
    
    it "should have a #winner_div" do
      do_get
      response.should have_tag("div[id=?]", "winner_div")
    end
    
    it "should show the final results" do
      template.should_receive(:render).with(:partial => "final_results", :locals => {:poll => @poll})
      do_get
    end
    
  end
  
  describe " when the Poll is active" do
    before do
      @poll.stub!(:active? => true)
    end
    
    it "should not have a #winner_div" do
      do_get
      response.should_not have_tag("div[id=?]", "winner_div")
    end
    
    it "should not show the final results" do
      template.should_not_receive(:render).with(:partial => "final_results", :locals => {:poll => @poll})
      do_get
    end
    
  end
  
end