require "rails_helper"

RSpec.describe "Public pages", type: :request do
  it "shows the landing page to visitors" do
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Looking for a Job, We can Deliver")
  end

  it "sends a signed-in user from the landing page to their dashboard" do
    sign_in create(:job_poster)
    get root_path
    expect(response).to redirect_to(poster_dashboard_path)
  end
end
