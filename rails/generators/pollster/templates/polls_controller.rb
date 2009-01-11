class <%= class_name.pluralize %>Controller < ApplicationController
  
  before_filter :load_items
  
  def load_items
    @<%= object_name %> = <%= class_name %>.find(params[:id]) if params[:id]
  end
  
  def index
    @<%= object_name %>s = <%= class_name %>.visible
  end

  def show
    redirect_to <%= object_name %>s_path
  end

  def new
    @<%= object_name %> = <%= class_name %>.new
  end

  def edit
  end

  def create
    @<%= object_name %> = <%= class_name %>.new(params[:<%= object_name %>])

    if @<%= object_name %>.save
      flash[:notice] = "<%= class_name %> successfully created"
      redirect_to <%= object_name %>s_path
    else
      render :action => "new"
    end
  end

  def update
    if @<%= object_name %>.update_attributes(params[:<%= object_name %>])
      flash[:notice] = '<%= class_name %> was successfully updated.'
      redirect_to <%= object_name %>s_path
    else
      flash[:error] = "An error occurred"
      render :action => "edit"
    end
  end

  def destroy
    @<%= object_name %>.destroy
    redirect_to <%= object_name %>s_path
  end
  
  def vote
    unless @<%= object_name %>.has_already_voted?(current_user)
      v = @<%= object_name %>.votes.build(:user => current_user, :vote => params[:<%= object_name %>]["vote"])
    
      if v.save
        flash[:notice] = "Vote cast!"
      else
        flash[:error] = "Something happened..."
      end
    end
    
    redirect_to <%= object_name %>s_path
  end
  
end