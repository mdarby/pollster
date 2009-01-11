require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/polls/_option_form.html.haml" do
  
  def do_get
    render :partial => "polls/option_form", :locals => {:option => []}
  end

  
  it "should render this form partial" do
    do_get
    response.should have_tag("div[class=?]", "option") do
      with_tag("input[name=?]", "poll[options][][options]")
      with_tag("a[onclick=?]", "$(this).up('.option').remove(); return false;")
    end
  end

  
end