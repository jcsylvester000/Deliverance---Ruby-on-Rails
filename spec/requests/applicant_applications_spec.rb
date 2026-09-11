require "rails_helper"

RSpec.describe "Applicant applications", type: :request do
  let(:applicant) { create(:applicant) }
  let(:job) { create(:job_posting, status: :published) }

  context "signed in as an applicant" do
    before { sign_in applicant }

    it "applies to a job and notifies the poster" do
      expect {
        post applicant_applications_path, params: { job_posting_id: job.id }
      }.to change(applicant.applications, :count).by(1)
        .and change(job.poster.notifications, :count).by(1)
      expect(response).to redirect_to(applicant_applications_path)
    end

    it "will not apply twice to the same active role" do
      create(:application, applicant: applicant, job_posting: job)
      expect {
        post applicant_applications_path, params: { job_posting_id: job.id }
      }.not_to change(applicant.applications, :count)
    end

    it "withdraws an application" do
      app = create(:application, applicant: applicant, job_posting: job)
      patch withdraw_applicant_application_path(app)
      expect(app.reload).to be_withdrawn
    end

    it "only shows the applicant's own applications" do
      create(:application, applicant: applicant, job_posting: job)
      other_job = create(:job_posting, title: "ZZ Unrelated Role", status: :published)
      create(:application, job_posting: other_job)
      get applicant_applications_path
      expect(response.body).to include(job.title)
      expect(response.body).not_to include("ZZ Unrelated Role")
    end
  end

  it "requires an applicant account" do
    sign_in create(:job_poster)
    get applicant_applications_path
    expect(response).to redirect_to(poster_dashboard_path)
  end
end
