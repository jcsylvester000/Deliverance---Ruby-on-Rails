require "rails_helper"

RSpec.describe "Role dashboards", type: :request do
  it "requires sign-in for the poster dashboard" do
    get poster_dashboard_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it "requires sign-in for the applicant dashboard" do
    get applicant_dashboard_path
    expect(response).to redirect_to(new_user_session_path)
  end

  context "as a job poster" do
    before { sign_in create(:job_poster) }

    it "can see the poster dashboard" do
      get poster_dashboard_path
      expect(response).to have_http_status(:ok)
    end

    it "is turned away from the applicant dashboard" do
      get applicant_dashboard_path
      expect(response).to redirect_to(poster_dashboard_path)
    end
  end

  context "as an applicant" do
    before { sign_in create(:applicant) }

    it "can see the applicant dashboard" do
      get applicant_dashboard_path
      expect(response).to have_http_status(:ok)
    end

    it "is turned away from the poster dashboard" do
      get poster_dashboard_path
      expect(response).to redirect_to(applicant_dashboard_path)
    end
  end
end
