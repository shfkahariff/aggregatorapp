class HomeController < ApplicationController
  def index
    @posts = Post.all
    @pagy, @posts = pagy(Post.order(publishdate: :desc), items: 20)
  end
end
