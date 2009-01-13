require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module <%= class_name %>Attributes
  def valid_attributes
    {
      :name          => "foo",
      :description   => "foo",
      :options       => ["first", "second", "third"],
      :ends_at       => Date.parse("2009-01-09"),
      :created_at    => Date.parse("2009-01-01"),
      :updated_at    => Date.parse("2009-01-01"),
      :created_by_id => 1
    }
  end
end

describe <%= class_name %> do

  include <%= class_name %>Attributes

  before do
    @<%= object_name %> = <%= class_name %>.create!(valid_attributes)
    @<%= object_name %>.stub!(:votes => [])
    @author = mock_model(User)
    @user = mock_model(User)
    
    @<%= object_name %>.stub!(:author => @author)
  end

  it "should be valid" do
    @<%= object_name %>.valid?.should be_true
  end

  it "should serialize #options" do
    @<%= object_name %>.options.is_a?(Array).should be_true
  end

  it "should know the total number of votes cast" do
    vote = mock_model(<%= class_name %>Vote)
    @<%= object_name %>.stub!(:votes => [vote])
    
    @<%= object_name %>.total_votes.should == 1
  end

  it "should be visible for a week after its end date" do
    Date.stub!(:today => Date.parse("2009-01-09"))
    @<%= object_name %>.stub!(:ends_at => Date.parse("2009-01-07"))
    
    @<%= object_name %>.visible?.should be_true
    
    @<%= object_name %>.stub!(:ends_at => Date.parse("2009-01-01"))
    @<%= object_name %>.visible?.should be_false
    
  end

  it "should be able to find all visible <%= class_name %>s" do
    <%= object_name %>_1 = mock_model(<%= class_name %>, :visible? => true)
    <%= object_name %>_2 = mock_model(<%= class_name %>, :visible? => false)
    <%= class_name %>.stub!(:all => [<%= object_name %>_1, <%= object_name %>_2])
    
    <%= class_name %>.visible.should == [<%= object_name %>_1]
  end


  describe " - Associations" do
    it "should know about votes" do
      @<%= object_name %>.votes.should == []
    end
    
    it "should know about voters" do
      @<%= object_name %>.voters.should == []
    end
    
    it "should know about its author" do
      @<%= object_name %>.author.should == @author
    end
    
  end

  describe " - Required attributes" do
    it "should require name" do
      @<%= object_name %>.name = nil
      @<%= object_name %>.valid?.should be_false
    end
    
    it "should require an end_date" do
      @<%= object_name %>.ends_at = nil
      @<%= object_name %>.valid?.should be_false
    end
    
    it "should require an author" do
      @<%= object_name %>.created_by_id = nil
      @<%= object_name %>.valid?.should be_false
    end
    
  end

  describe " that has no votes" do
    before do
      @<%= object_name %>.stub!(:votes => [])
    end
  
    it "should know that it has no votes" do
      @<%= object_name %>.has_votes?.should be_false
    end
  end

  describe " that has votes" do
    before do
      @vote = mock_model(<%= class_name %>Vote)
      @<%= object_name %>.stub!(:votes => [@vote])
    end
  
    it "should know that it has votes" do
      @<%= object_name %>.has_votes?.should be_true
    end
    
    it "should know how to calculate the current results" do
      @<%= object_name %>.stub!(:options => ["first", "second", "third"])
      @<%= object_name %>.stub!(:num_votes_for)
      @<%= object_name %>.stub!(:percentage_of_votes_for).with("first").and_return(10.0)
      @<%= object_name %>.stub!(:percentage_of_votes_for).with("second").and_return(60.0)
      @<%= object_name %>.stub!(:percentage_of_votes_for).with("third").and_return(30.00)
      
      @<%= object_name %>.current_results_percentages.should == [10.0, 60.0, 30.0]
    end

    it "should know how to get a vote count for an option" do
      vote_1 = mock_model(<%= class_name %>Vote, :vote => "first")
      vote_2 = mock_model(<%= class_name %>Vote, :vote => "second")
      vote_3 = mock_model(<%= class_name %>Vote, :vote => "first")
      @<%= object_name %>.stub!(:votes => [vote_1, vote_2, vote_3])
      
      @<%= object_name %>.num_votes_for("first").should == 2
    end
  
    it "should be able to generate a legend for the results chart" do
      @<%= object_name %>.stub!(:options => ["first", "second", "third"])
      @<%= object_name %>.stub!(:formatted_percentage_of_votes_for).with("first").and_return("10%")
      @<%= object_name %>.stub!(:formatted_percentage_of_votes_for).with("second").and_return("60%")
      @<%= object_name %>.stub!(:formatted_percentage_of_votes_for).with("third").and_return("20%")
      
      @<%= object_name %>.pie_legend.should == ["%231 (10%)", "%232 (60%)", "%233 (20%)"]
    end
  
    it "should be able to calculate the percentage of votes cast for an option" do
      @<%= object_name %>.should_receive(:num_votes_for).with("first").and_return(10)
      @<%= object_name %>.stub!(:total_votes => 100.0)

      @<%= object_name %>.percentage_of_votes_for("first").should == 0.1
    end
  
    it "should be able to format the percentage of votes cast for an option" do
      @<%= object_name %>.should_receive(:num_votes_for).with("first").and_return(10)
      @<%= object_name %>.stub!(:total_votes => 100.0)

      @<%= object_name %>.formatted_percentage_of_votes_for("first").should == "10%"
    end
  
    it "should know if a User has already voted" do
      user = mock_model(User)
      user2 = mock_model(User)
      @<%= object_name %>.stub!(:voters => [user])

      @<%= object_name %>.has_already_voted?(user).should be_true
      @<%= object_name %>.has_already_voted?(user2).should be_false
    end
  end

  describe " that has not yet reached its end date" do
    before do
      @<%= object_name %>.ends_at = 3.days.from_now
    end
    
    it "should be considered active" do
      @<%= object_name %>.active?.should be_true
    end
    
    it "should allow voting by a new voter" do
      user = mock_model(User)
      @<%= object_name %>.stub!(:has_already_voted? => false)
      
      @<%= object_name %>.can_by_voted_on_by(user).should be_true
    end
    
  end
  
  describe " that is on its last day of voting" do
    it "should know that it's still open" do
      date = Date.parse("2009-01-10")
      @<%= object_name %>.stub!(:ends_at => date)
      Time.stub!(:now => date.end_of_day - 1.second)
      
      @<%= object_name %>.active?.should be_true
    end
  end
  
  describe " that has passed its end date" do
    before do
      @<%= object_name %>.ends_at = Date.yesterday
    end
    
    it "should not be considered active" do
      @<%= object_name %>.active?.should be_false
    end
    
    it "should not allow voting by a new voter" do
      user = mock_model(User)
      @<%= object_name %>.stub!(:has_already_voted? => false)
      
      @<%= object_name %>.can_by_voted_on_by(user).should be_false
    end
  
    it "should know who the winner is" do
      @<%= object_name %>.stub!(:options => ["first", "second", "third"])
      @<%= object_name %>.stub!(:winning_percentage => 0.9)
      @<%= object_name %>.stub!(:current_results_percentages => [0.0, 0.9, 0.1])
      
      @<%= object_name %>.winner.should == "second"
    end
  
    it "should know what the winning percentage was" do
      @<%= object_name %>.stub!(:current_results_percentages => [0.4, 0.5, 0.1])
      @<%= object_name %>.winning_percentage.should == 0.5
    end
    
    
    describe " and ends in a tie" do
      before do
        @<%= object_name %>.stub!(:options => ["first", "second", "third"])
        @<%= object_name %>.stub!(:winning_percentage => 0.4)
        @<%= object_name %>.stub!(:current_results_percentages => [0.4, 0.4, 0.2])
      end
      
      it "should know that it ends in a tie" do
        @<%= object_name %>.ends_in_tie?.should be_true
      end
      
      it "should know which options tied" do
        @<%= object_name %>.winners.should == ["first", "second"]
      end
      
    end
    
  end
  
end