require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Poll do

  before do
    @poll = Factory(:poll, :votes => [])
    @author = mock_model(User)
    @user = mock_model(User)
    
    @poll.stub!(:author => @author)
  end

  it "should be valid" do
    @poll.valid?.should be_true
  end

  it "should serialize #options" do
    @poll.options.is_a?(Array).should be_true
  end

  it "should know the total number of votes cast" do
    vote = mock_model(PollVote)
    @poll.stub!(:votes => [vote])
    
    @poll.total_votes.should == 1
  end

  it "should know how to shave the options yak" do
    @poll.options = [{"options" => "first"}, {"options" => "second"}, {"options" => "third"}]
    @poll.save
    @poll.options.should == ["first", "second", "third"]
  end

  it "should be visible for a week after its end date" do
    Date.stub!(:today => Date.parse("2009-01-09"))
    @poll.stub!(:ends_at => Date.parse("2009-01-07"))
    
    @poll.visible?.should be_true
    
    @poll.stub!(:ends_at => Date.parse("2009-01-01"))
    @poll.visible?.should be_false
    
  end

  it "should be able to find all visible Polls" do
    poll_1 = mock_model(Poll, :visible? => true)
    poll_2 = mock_model(Poll, :visible? => false)
    Poll.stub!(:all => [poll_1, poll_2])
    
    Poll.visible.should == [poll_1]
  end


  describe " - Associations" do
    it "should know about votes" do
      @poll.votes.should == []
    end
    
    it "should know about voters" do
      @poll.voters.should == []
    end
    
    it "should know about its author" do
      @poll.author.should == @author
    end
    
  end

  describe " - Required attributes" do
    it "should require name" do
      @poll.name = nil
      @poll.valid?.should be_false
    end
    
    it "should require an end_date" do
      @poll.ends_at = nil
      @poll.valid?.should be_false
    end
    
    it "should require an author" do
      @poll.created_by_id = nil
      @poll.valid?.should be_false
    end
    
  end

  describe " that has no votes" do
    before do
      @poll.stub!(:votes => [])
    end
    
    it "should be updatable by the author" do
      @poll.is_updatable_by(@author).should be_true
      @poll.is_updatable_by(@user).should be_false
    end
    
    it "should be deletable by the author" do
      @poll.is_deletable_by(@author).should be_true
      @poll.is_deletable_by(@user).should be_false
    end
  
    it "should know that it has no votes" do
      @poll.has_votes?.should be_false
    end
  end

  describe " that has votes" do
    before do
      @vote = Factory(:poll_vote)
      @poll.stub!(:votes => [@vote])
    end
    
    it "should not be updatable" do
      @poll.is_updatable_by(@author).should be_false
      @poll.is_updatable_by(@user).should be_false
    end
    
    it "should not be deletable" do
      @poll.is_deletable_by(@author).should be_false
      @poll.is_deletable_by(@user).should be_false
    end
  
    it "should know that it has votes" do
      @poll.has_votes?.should be_true
    end
    
    it "should know how to calculate the current results" do
      @poll.stub!(:num_votes)
      @poll.stub!(:percentage_of_votes_for).with("first").and_return(10.0)
      @poll.stub!(:percentage_of_votes_for).with("second").and_return(60.0)
      @poll.stub!(:percentage_of_votes_for).with("third").and_return(30.00)
      
      @poll.current_results_percentages.should == [10.0, 60.0, 30.0]
    end

    it "should know how to get a vote count for an option" do
      vote_1 = mock_model(PollVote, :vote => "first")
      vote_2 = mock_model(PollVote, :vote => "second")
      vote_3 = mock_model(PollVote, :vote => "first")
      @poll.stub!(:votes => [vote_1, vote_2, vote_3])
      
      @poll.num_votes_for("first").should == 2
    end
  
    it "should be able to generate a legend for the results chart" do
      @poll.stub!(:formatted_percentage_of_votes_for).with("first").and_return("10%")
      @poll.stub!(:formatted_percentage_of_votes_for).with("second").and_return("60%")
      @poll.stub!(:formatted_percentage_of_votes_for).with("third").and_return("20%")
      
      @poll.pie_legend.should == ["%231 (10%)", "%232 (60%)", "%233 (20%)"]
    end
  
    it "should be able to calculate the percentage of votes cast for an option" do
      @poll.should_receive(:num_votes_for).with("first").and_return(10)
      @poll.stub!(:total_votes => 100.0)

      @poll.percentage_of_votes_for("first").should == 0.1
    end
  
    it "should be able to format the percentage of votes cast for an option" do
      @poll.should_receive(:num_votes_for).with("first").and_return(10)
      @poll.stub!(:total_votes => 100.0)

      @poll.formatted_percentage_of_votes_for("first").should == "10%"
    end
  
    it "should know if a User has already voted" do
      user = mock_model(User)
      user2 = mock_model(User)
      @poll.stub!(:voters => [user])

      @poll.has_already_voted?(user).should be_true
      @poll.has_already_voted?(user2).should be_false
    end
  end

  describe " that has not yet reached its end date" do
    before do
      @poll.ends_at = 3.days.from_now
    end
    
    it "should be considered active" do
      @poll.active?.should be_true
    end
    
    it "should allow voting by a new voter" do
      user = mock_model(User)
      @poll.stub!(:has_already_voted? => false)
      
      @poll.can_by_voted_on_by(user).should be_true
    end
    
  end
  
  describe " that is on its last day of voting" do
    it "should know that it's still open" do
      date = Date.parse("2009-01-10")
      @poll.stub!(:end_date => date)
      Time.stub!(:now => date.end_of_day - 1.second)
      
      @poll.active?.should be_true
    end
  end
  
  describe " that has passed its end date" do
    before do
      @poll.ends_at = Date.yesterday
    end
    
    it "should not be considered active" do
      @poll.active?.should be_false
    end
    
    it "should not allow voting by a new voter" do
      user = mock_model(User)
      @poll.stub!(:has_already_voted? => false)
      
      @poll.can_by_voted_on_by(user).should be_false
    end
  
    it "should know who the winner is" do
      @poll.stub!(:winning_percentage => 0.9)
      @poll.stub!(:current_results_percentages => [0.0, 0.9, 0.1])
      
      @poll.winner.should == "second"
    end
  
    it "should know what the winning percentage was" do
      @poll.stub!(:current_results_percentages => [0.4, 0.5, 0.1])
      @poll.winning_percentage.should == 0.5
    end
    
    
    describe " and ends in a tie" do
      before do
        @poll.stub!(:winning_percentage => 0.4)
        @poll.stub!(:current_results_percentages => [0.4, 0.4, 0.2])
      end
      
      it "should know that it ends in a tie" do
        @poll.ends_in_tie?.should be_true
      end
      
      it "should know which options tied" do
        @poll.winners.should == ["first", "second"]
      end
      
    end
    
  end

end