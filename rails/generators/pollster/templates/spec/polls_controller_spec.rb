require File.dirname(__FILE__) + '/../spec_helper'

describe PollsController do
  it_should_behave_like "a user is logged in"
  
  describe "handling the load_items method" do
    before do
      @poll = mock_model(Poll)
      Poll.stub!(:find => @poll)
    end
    
    describe " with params[:id]" do
      it "should setup @poll" do
        get :show, :id => 1
        assigns[:poll].should == @poll
      end
    end
    
    describe " without params[:id]" do
      it "should not setup @poll" do
        Poll.stub!(:visible)
        get :index
        assigns[:poll].should == nil
      end
    end
  end
  
  describe "handling GET /polls" do

    before do
      @poll = mock_model(Poll)
      Poll.stub!(:visible).and_return([@poll])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all visible polls" do
      Poll.should_receive(:visible).and_return([@poll])
      do_get
    end
  
    it "should assign the found polls for the view" do
      do_get
      assigns[:polls].should == [@poll]
    end
  end

  describe "handling GET /poll/1" do
    it "should redirect to index" do
      Poll.stub!(:find => @poll)
      get :show, :id => 1
      response.should redirect_to polls_path
    end
  end

  describe "handling GET /polls/new" do
    
    before do
      @poll = mock_model(Poll)
      Poll.stub!(:new => @poll)
    end
  
    def do_get
      controller.stub!(:render).with(:partial => 'new', :locals => {:poll => @poll}) 
      get :new
    end
  
    it "should render new template" do
      do_get
      response.should render_template(:new)
    end
  
    it "should create an new poll" do
      Poll.should_receive(:new).and_return(@poll)
      do_get
    end
  
    it "should not save the new poll" do
      @poll.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new poll for the view" do
      do_get
      assigns[:poll].should equal(@poll)
    end
  end

  describe "handling GET /polls/1/edit" do

    before do
      @poll = mock_model(Poll)
      Poll.stub!(:find => @poll)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "text/javascript"
      controller.stub!(:render).with(:partial => 'edit', :locals => {:poll => @poll}) 
      get :edit, :id => 1
    end
  
    it "should render edit template" do
      do_get
      response.should render_template(:edit)
    end
  
    it "should find the poll requested" do
      Poll.should_receive(:find).and_return(@poll)
      do_get
    end
  
    it "should assign the found Poll for the view" do
      do_get
      assigns[:poll].should equal(@poll)
    end
  end

  describe "handling POST /polls" do

    before do
      @poll = Factory(:poll)
      Poll.stub!(:new => @poll)
    end
    
    describe "with successful save" do
  
      def do_post
        @poll.should_receive(:save).and_return(true)
        post :create, :poll => {}
      end
  
      it "should create a new poll" do
        Poll.should_receive(:new).with({}).and_return(@poll)
        do_post
      end

      it "should set a flash message" do
        do_post
        flash[:notice].should == "Poll successfully created"
      end

      it "should redirect to the new Poll" do
        do_post
        response.should redirect_to(polls_path)
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @poll.should_receive(:save).and_return(false)
        post :create, :poll => {}
      end
  
      it "should show the error_div with error messages" do
        do_post
        response.should render_template(:new)
      end
      
    end
  end

  describe "handling PUT /polls/1" do

    before do
      @poll = Factory(:poll)
      Poll.stub!(:find => @poll)
    end
    
    describe "with successful update" do

      def do_put
        @poll.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the poll requested" do
        Poll.should_receive(:find).with("1").and_return(@poll)
        do_put
      end

      it "should update the found poll" do
        do_put
        assigns(:poll).should equal(@poll)
      end

      it "should assign the found poll for the view" do
        do_put
        assigns(:poll).should equal(@poll)
      end

      it "should redirect to the Poll" do
        do_put
        response.should redirect_to(polls_path)
      end

      it "should set a flash message" do
        do_put
        flash[:notice].should == "Poll was successfully updated."
      end

    end
    
    describe "with failed update" do

      def do_put
        @poll.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should set a flash message" do
        do_put
        flash[:error].should == "An error occurred"
      end
      
      it "should render the edit template" do
        do_put
        response.should render_template(:edit)
      end

    end
  end

  describe "handling DELETE /polls/1" do

    before do
      @poll = mock_model(Poll, :destroy => true, :save => true)
      Poll.stub!(:find => @poll)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the poll requested" do
      Poll.should_receive(:find).with("1").and_return(@poll)
      do_delete
    end
  
    it "should call destroy on the found poll" do
      @poll.should_receive(:destroy).and_return(true)
      do_delete
    end
  
  end

  describe "handling POST /polls/1/vote" do
    before do
      @vote = mock_model(PollVote, :null_object => true)
      @poll = Factory(:poll)
      @user = mock_model(User)
      @poll.votes.stub!(:build => @vote)
      
      Poll.stub!(:find => @poll)
      controller.stub!(:current_user => @user)
    end

    describe "with repeat voter" do
      def do_post
        post :vote, :id => 1, :poll => {"vote" => "first"}
      end
      
      it "should redirect without voting" do
        @poll.stub!(:has_already_voted? => true)
        @poll.votes.should_not_receive(:build).with(:user => @user, :vote => "first").and_return(@vote)
        
        do_post
      end
    end

    describe "when a new voter" do
      before do
        @poll.stub!(:has_already_voted? => false)
      end
      
      describe "with successful save" do
        def do_post
          @vote.should_receive(:save).and_return(true)
          post :vote, :id => 1, :poll => {"vote" => "first"}
        end

        it "should create a new vote" do
          @poll.votes.should_receive(:build).with(:user => @user, :vote => "first").and_return(@vote)
          do_post
        end

        it "should set a flash message" do
          do_post
          flash[:notice].should == "Vote cast!"
        end

        it "should redirect to the poll" do
          do_post
          response.should redirect_to(polls_path)
        end

      end

      describe "with failed save" do

        def do_post
          @vote.should_receive(:save).and_return(false)
          post :vote, :id => 1, :poll => {}
        end

        it "should show an error message" do
          do_post
          flash[:error].should == "Something happened..."
        end

        it "should redirec to the poll" do
          do_post
          response.should redirect_to(polls_path)
        end

      end
    end
  end

end

# unless @poll.has_already_voted?(current_user)