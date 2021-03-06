class PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.create!(post_params)
    if @post.save
      redirect_to post_path(@post), notice: "Post successfully created"
    else
      flash[:alert] = "Fields not entered correctly"
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user != current_user
      flash[:alert] = "Only the author of the post can edit!"
      redirect_to post_path(@post)
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.user == current_user
      @post.update(post_params)
      redirect_to post_path(@post), notice: "Post successfully updated"
    else
      flash[:alert] = "Fields not entered correctly"
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user == current_user
      @post.destroy
    else
      flash[:alert] = "Only the author of the post can delete"
    end
    redirect_to posts_path
  end

  private
    def post_params
      params.require(:post).permit(:title, :body, :photo_url)
    end

end
