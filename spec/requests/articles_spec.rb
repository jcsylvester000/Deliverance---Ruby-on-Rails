require "rails_helper"

RSpec.describe "Blog", type: :request do
  it "lists articles to everyone" do
    get articles_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(Article.all.first.title)
  end

  it "shows a single article" do
    article = Article.all.first
    get article_path(article)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(article.title)
  end

  it "returns 404 for an unknown article" do
    get article_path("no-such-article")
    expect(response).to have_http_status(:not_found)
  end
end
