require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/polls/_current_results.html.haml" do
  
  before do
    Gchart.stub!(:pie)
    
    @poll = Factory(:poll)
    @poll.stub!(:votes => [mock_model(PollVote)], :total_votes => 1.0, 
                :pie_legend => [], :current_results_percentages => [])
  end

  def do_get
    render :partial => "polls/current_results", :locals => {:poll => @poll}
  end

  it "should show this title" do
    do_get
    response.should include_text "Results after 1 vote"
  end

  it "should show a numbered list of the options" do
    do_get
    response.should have_tag("ol") do
      with_tag("li", "first")
      with_tag("li", "second")
      with_tag("li", "third")
    end
  end

  it "should show a 3D GoogleChart" do
    Gchart.should_receive(:pie_3d)
    do_get
  end
  
end