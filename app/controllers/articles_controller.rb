# Public blog — static content served from the Article PORO (no database).
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @more    = Article.all.reject { |a| a.slug == @article.slug }.first(3)
  end
end
