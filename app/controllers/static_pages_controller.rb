class StaticPagesController < ApplicationController
  def top
    @posts = Post.desc.limit(20).includes(:user)
  end

  def about
  end
end
