require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/polls/index.html.haml" do
  
  before do
    assigns[:polls] = []
    template.stub!(:creatable => false)
  end

  def do_get
    render "/polls/index.html.haml"
  end


  it "should have these crumbs" do
    do_get
    session[:crumbs].should have_crumb_to(polls_path).named("Polls")
  end
  
  it "should have this title" do
    template.should_receive(:title_block).with("Listing polls")
    do_get
  end
  
  it "should show polls" do
    template.should_receive(:render).with(:partial => "poll", :collection => [])
    do_get
  end
  
  
  describe " when a Poll is creatable" do
    it "should show a create link" do
      template.stub!(:creatable => true)
      do_get
      response.should have_tag("a[href=?]", new_poll_path, "New")
    end
  end
  
  describe " when a Poll is not creatable" do
    it "should not show a create link" do
      template.stub!(:creatable => false)
      do_get
      response.should_not have_tag("a[href=?]", new_poll_path)
    end
  end
  
end