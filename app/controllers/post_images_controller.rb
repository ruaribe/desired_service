class PostImagesController < ApplicationController
  before_action :logged_in_user

  before_action do
    @post = current_user.posts.find(params[:post_id])
  end

  def index
    @images = @post.images.order(:id)
  end

  def new
    @image = @post.images.build
  end

  def create
    @image = @post.images.build(image_params)
    if @image.save
      flash[:success] = '画像を追加しました。'
      redirect_to post_images_path
    else
      render 'new'
    end
  end

  def show
    redirect_to action: 'edit'
  end

  def edit
    @image = @post.images.find(params[:id])
  end

  def update
    @image = @post.images.find(params[:id])
    @image.assign_attributes(image_params)
    if @image.save
      flash[:success] = '画像を更新しました。'
      redirect_to post_images_path
    else
      render 'edit'
    end
  end

  def destroy
    @image = @post.images.find(params[:id])
    @image.destroy
    flash[:success] = '画像を削除しました。'
    redirect_to post_images_path
  end

  private def image_params
    params.require(:post_image).permit(:new_data, :alt_text)
  end

  def sort
    image = @post.images[params[:from].to_i]
    image.insert_at(params[:to].to_i + 1)
    head :ok
  end
end
