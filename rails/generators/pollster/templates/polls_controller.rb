class PollsController < ApplicationController
  
  before_filter :load_items
  
  def load_items
    @poll = Poll.find(params[:id]) if params[:id]
  end
  
  def index
    @polls = Poll.visible
  end

  def show
    redirect_to polls_path
  end

  def new
    @poll = Poll.new
  end

  def edit
  end

  def create
    @poll = Poll.new(params[:poll])

    if @poll.save
      flash[:notice] = "Poll successfully created"
      redirect_to polls_path
    else
      render :action => "new"
    end
  end

  def update
    if @poll.update_attributes(params[:poll])
      flash[:notice] = 'Poll was successfully updated.'
      redirect_to polls_path
    else
      flash[:error] = "An error occurred"
      render :action => "edit"
    end
  end

  def destroy
    @poll.destroy
    redirect_to polls_path
  end
  
  def vote
    unless @poll.has_already_voted?(current_user)
      v = @poll.votes.build(:user => current_user, :vote => params[:poll]["vote"])
    
      if v.save
        flash[:notice] = "Vote cast!"
      else
        flash[:error] = "Something happened..."
      end
    end
    
    redirect_to polls_path
  end
  
end