require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/polls/_vote.html.haml" do
  
  before do
    @poll = Factory(:poll)
  end

  def do_get
    render :partial => "polls/vote", :locals => {:poll => @poll}
  end

  
  it "should render this form" do
    do_get
    response.should have_tag("form[action=?]", vote_poll_path(@poll)) do
      with_tag("select[name=?]", "poll[vote]")
      with_tag("input[type=?]", "submit")
    end
  end
  
end