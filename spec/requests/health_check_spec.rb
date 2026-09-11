require "rails_helper"

# Phase 0 proof-of-life: if this is green, the whole stack boots in the test environment.
RSpec.describe "Health check", type: :request do
  it "responds 200 at /up" do
    get "/up"
    expect(response).to have_http_status(:ok)
  end
end
