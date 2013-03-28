class CommentsController < ApplicationController
  def index
    @comments = Comment.all
    @comment = Comment.new
  end  
  
  def new
    render :nothing => true
  end
  
  def show
    render :index
  end
  
  def create
    @comment = Comment.new( params[:comment] )
    
    respond_to do |format|
      if @comment.save
        flash.now[:notice] = "Comment successfully created"
        format.html { redirect_to @comment, :layout => !request.xhr?, :status => :created }
        format.js { render :status => :created, :location => @comment, :layout => !request.xhr? }
      else
        flash.now[:error] = "Comment couldn't be created"
        format.html do
          @comments = Comment.all
          render :action => "index", :layout => !request.xhr?, :status => :unprocessable_entity
        end
        format.js { render :status => :unprocessable_entity }
     end
   end
  end
  
  ## with a few template additions, the above should be equivalent to:
  # respond_to :html, :js
  #
  # def create
  #   @comment = Comment.new( params[:comment] )
  # 
  #   flash[:notice] = "Comment successfully created" if @comment.save
  #   respond_with( @comment, :layout => !request.xhr? )
  # end
end


