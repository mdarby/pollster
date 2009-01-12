require File.dirname(__FILE__) + '/../spec_helper'

describe <%= class_name %>sController do
  
  before do
    @request.session[:crumbs] = []
    @request.session[:user_id] = 1
    current_user = mock_model(User, :display_name => 'Matt Darby')   
    User.stub!(:find => current_user)
    controller.stub!(:current_user => current_user)
  end
  
  describe "handling the load_items method" do
    before do
      @<%= object_name %> = mock_model(<%= class_name %>)
      <%= class_name %>.stub!(:find => @<%= object_name %>)
    end
    
    describe " with params[:id]" do
      it "should setup @<%= object_name %>" do
        get :show, :id => 1
        assigns[:<%= object_name %>].should == @<%= object_name %>
      end
    end
    
    describe " without params[:id]" do
      it "should not setup @<%= object_name %>" do
        <%= class_name %>.stub!(:visible)
        get :index
        assigns[:<%= object_name %>].should == nil
      end
    end
  end
  
  describe "handling GET /<%= object_name %>s" do

    before do
      @<%= object_name %> = mock_model(<%= class_name %>)
      <%= class_name %>.stub!(:visible).and_return([@<%= object_name %>])
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
  
    it "should find all visible <%= object_name %>s" do
      <%= class_name %>.should_receive(:visible).and_return([@<%= object_name %>])
      do_get
    end
  
    it "should assign the found <%= object_name %>s for the view" do
      do_get
      assigns[:<%= object_name %>s].should == [@<%= object_name %>]
    end
  end

  describe "handling GET /<%= object_name %>/1" do
    it "should redirect to index" do
      <%= class_name %>.stub!(:find => @<%= object_name %>)
      get :show, :id => 1
      response.should redirect_to <%= object_name %>s_path
    end
  end

  describe "handling GET /<%= object_name %>s/new" do
    
    before do
      @<%= object_name %> = mock_model(<%= class_name %>)
      <%= class_name %>.stub!(:new => @<%= object_name %>)
    end
  
    def do_get
      controller.stub!(:render).with(:partial => 'new', :locals => {:<%= object_name %> => @<%= object_name %>}) 
      get :new
    end
  
    it "should render new template" do
      do_get
      response.should render_template(:new)
    end
  
    it "should create an new <%= object_name %>" do
      <%= class_name %>.should_receive(:new).and_return(@<%= object_name %>)
      do_get
    end
  
    it "should not save the new <%= object_name %>" do
      @<%= object_name %>.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new <%= object_name %> for the view" do
      do_get
      assigns[:<%= object_name %>].should equal(@<%= object_name %>)
    end
  end

  describe "handling GET /<%= object_name %>s/1/edit" do

    before do
      @<%= object_name %> = mock_model(<%= class_name %>)
      <%= class_name %>.stub!(:find => @<%= object_name %>)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "text/javascript"
      controller.stub!(:render).with(:partial => 'edit', :locals => {:<%= object_name %> => @<%= object_name %>}) 
      get :edit, :id => 1
    end
  
    it "should render edit template" do
      do_get
      response.should render_template(:edit)
    end
  
    it "should find the <%= object_name %> requested" do
      <%= class_name %>.should_receive(:find).and_return(@<%= object_name %>)
      do_get
    end
  
    it "should assign the found <%= class_name %> for the view" do
      do_get
      assigns[:<%= object_name %>].should equal(@<%= object_name %>)
    end
  end

  describe "handling POST /<%= object_name %>s" do

    before do
      @<%= object_name %> = mock_model(<%= class_name %>)
      <%= class_name %>.stub!(:new => @<%= object_name %>)
    end
    
    describe "with successful save" do
  
      def do_post
        @<%= object_name %>.should_receive(:save).and_return(true)
        post :create, :<%= object_name %> => {}
      end
  
      it "should create a new <%= object_name %>" do
        <%= class_name %>.should_receive(:new).with({}).and_return(@<%= object_name %>)
        do_post
      end

      it "should set a flash message" do
        do_post
        flash[:notice].should == "<%= class_name %> successfully created"
      end

      it "should redirect to the new <%= class_name %>" do
        do_post
        response.should redirect_to(<%= object_name %>s_path)
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @<%= object_name %>.should_receive(:save).and_return(false)
        post :create, :<%= object_name %> => {}
      end
  
      it "should show the error_div with error messages" do
        do_post
        response.should render_template(:new)
      end
      
    end
  end

  describe "handling PUT /<%= object_name %>s/1" do

    before do
      @<%= object_name %> = mock_model(<%= class_name %>)
      <%= class_name %>.stub!(:find => @<%= object_name %>)
    end
    
    describe "with successful update" do

      def do_put
        @<%= object_name %>.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the <%= object_name %> requested" do
        <%= class_name %>.should_receive(:find).with("1").and_return(@<%= object_name %>)
        do_put
      end

      it "should update the found <%= object_name %>" do
        do_put
        assigns(:<%= object_name %>).should equal(@<%= object_name %>)
      end

      it "should assign the found <%= object_name %> for the view" do
        do_put
        assigns(:<%= object_name %>).should equal(@<%= object_name %>)
      end

      it "should redirect to the <%= class_name %>" do
        do_put
        response.should redirect_to(<%= object_name %>s_path)
      end

      it "should set a flash message" do
        do_put
        flash[:notice].should == "<%= class_name %> was successfully updated."
      end

    end
    
    describe "with failed update" do

      def do_put
        @<%= object_name %>.should_receive(:update_attributes).and_return(false)
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

  describe "handling DELETE /<%= object_name %>s/1" do

    before do
      @<%= object_name %> = mock_model(<%= class_name %>, :destroy => true, :save => true)
      <%= class_name %>.stub!(:find => @<%= object_name %>)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the <%= object_name %> requested" do
      <%= class_name %>.should_receive(:find).with("1").and_return(@<%= object_name %>)
      do_delete
    end
  
    it "should call destroy on the found <%= object_name %>" do
      @<%= object_name %>.should_receive(:destroy).and_return(true)
      do_delete
    end
  
  end

  describe "handling POST /<%= object_name %>s/1/vote" do
    before do
      @vote = mock_model(<%= class_name %>Vote, :null_object => true)
      @<%= object_name %> = mock_model(<%= class_name %>, :votes => self)
      @user = mock_model(User)
      @<%= object_name %>.votes.stub!(:build => @vote)
      
      <%= class_name %>.stub!(:find => @<%= object_name %>)
      controller.stub!(:current_user => @user)
    end

    describe "with repeat voter" do
      def do_post
        post :vote, :id => 1, :<%= object_name %> => {"vote" => "first"}
      end
      
      it "should redirect without voting" do
        @<%= object_name %>.stub!(:has_already_voted? => true)
        @<%= object_name %>.votes.should_not_receive(:build).with(:user => @user, :vote => "first").and_return(@vote)
        
        do_post
      end
    end

    describe "when a new voter" do
      before do
        @<%= object_name %>.stub!(:has_already_voted? => false)
      end
      
      describe "with successful save" do
        def do_post
          @vote.should_receive(:save).and_return(true)
          post :vote, :id => 1, :<%= object_name %> => {"vote" => "first"}
        end

        it "should create a new vote" do
          @<%= object_name %>.votes.should_receive(:build).with(:user => @user, :vote => "first").and_return(@vote)
          do_post
        end

        it "should set a flash message" do
          do_post
          flash[:notice].should == "Vote cast!"
        end

        it "should redirect to the <%= object_name %>" do
          do_post
          response.should redirect_to(<%= object_name %>s_path)
        end

      end

      describe "with failed save" do

        def do_post
          @vote.should_receive(:save).and_return(false)
          post :vote, :id => 1, :<%= object_name %> => {}
        end

        it "should show an error message" do
          do_post
          flash[:error].should == "Something happened..."
        end

        it "should redirec to the <%= object_name %>" do
          do_post
          response.should redirect_to(<%= object_name %>s_path)
        end

      end
    end
  end

end

# unless @<%= object_name %>.has_already_voted?(current_user)