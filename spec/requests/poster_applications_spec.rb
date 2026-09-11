require "rails_helper"

RSpec.describe "Poster applications pipeline", type: :request do
  let(:poster) { create(:job_poster) }
  let(:job) { create(:job_posting, poster: poster, status: :published) }

  context "signed in as the owning poster" do
    before { sign_in poster }

    it "lists applications to the poster's own postings" do
      app = create(:application, job_posting: job)
      get poster_applications_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(app.applicant.display_name)
    end

    it "advances an application and notifies the applicant" do
      app = create(:application, job_posting: job, stage: :applied)
      expect {
        patch advance_poster_application_path(app)
      }.to change { app.reload.stage }.from("applied").to("under_review")
        .and change(app.applicant.notifications, :count).by(1)
    end

    it "rejects an application" do
      app = create(:application, job_posting: job)
      patch reject_poster_application_path(app)
      expect(app.reload).to be_rejected
    end

    it "cannot touch an application to another poster's posting" do
      other = create(:application)
      get poster_application_path(other)
      expect(response).to have_http_status(:not_found)
    end
  end
end
