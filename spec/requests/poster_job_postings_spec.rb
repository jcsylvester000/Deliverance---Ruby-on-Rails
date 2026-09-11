require "rails_helper"

RSpec.describe "Poster job postings", type: :request do
  let(:poster) { create(:job_poster) }

  context "when signed in as a poster" do
    before { sign_in poster }

    it "creates a posting" do
      expect {
        post poster_job_postings_path, params: { job_posting: {
          title: "Barista", description: "Make coffee", location: "Manila",
          employment_type: "gig", work_arrangement: "onsite", status: "published"
        } }
      }.to change(poster.job_postings, :count).by(1)
      expect(response).to redirect_to(poster_job_postings_path)
    end

    it "rejects an 11th active posting" do
      create_list(:job_posting, 10, poster: poster, status: :published)
      expect {
        post poster_job_postings_path, params: { job_posting: {
          title: "One too many", description: "x",
          employment_type: "gig", work_arrangement: "remote", status: "published"
        } }
      }.not_to change(poster.job_postings, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "closes a posting to free a slot" do
      job = create(:job_posting, poster: poster, status: :published)
      patch close_poster_job_posting_path(job)
      expect(job.reload).to be_closed
    end

    it "cannot touch another poster's posting" do
      other = create(:job_posting)
      get edit_poster_job_posting_path(other)
      expect(response).to have_http_status(:not_found)
    end
  end

  context "when signed in as an applicant" do
    it "is turned away from the poster area" do
      sign_in create(:applicant)
      get poster_job_postings_path
      expect(response).to redirect_to(applicant_dashboard_path)
    end
  end
end
