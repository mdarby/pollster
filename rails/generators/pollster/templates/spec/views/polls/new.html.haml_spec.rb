require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/polls/new.html.haml" do
  
  before do
    @poll = Factory(:poll)
    assigns[:poll] = @poll
  end

  def do_get
    render "/polls/new.html.haml"
  end


  it "should have these crumbs" do
    do_get
    session[:crumbs].should have_crumb_to(polls_path).named("Polls")
    session[:crumbs].should have_crumb_to(new_poll_path).named("New")
  end
  
  it "should have this title" do
    template.should_receive(:title_block).and_return("New poll")
    do_get
  end

  it "should have this form" do
    do_get
    
    response.should have_tag("form[action=?]", poll_path(@poll)) do
      with_tag("input[type=?][name=?]", "hidden", "poll[created_by_id]")
      with_tag("input[name=?]", "poll[name]")
      with_tag("input[name=?]", "poll[ends_at]")
      with_tag("textarea[name=?]", "poll[description]")
      with_tag("input[type=?]", "submit")
      with_tag("a[href=?]", polls_path)
    end
  end
  
  
  describe " -- the options partial" do
    it "should render a box named 'options'" do
      do_get
      response.should have_box_named("Candidates")
    end

    it "should have a div #options" do
      do_get
      response.should have_tag("div[id=?]", "options")
    end

    it "should render the option partial twice" do
      template.should_receive(:render).with(:partial => 'option_form', :locals => {:option => []}).exactly(3).times
      do_get
    end

    it "should show an 'add_option_link' link" do
      template.should_receive(:add_option_link).with(@poll, "Add an option")
      do_get
    end

  end
  
end