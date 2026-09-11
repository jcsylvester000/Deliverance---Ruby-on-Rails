require "rails_helper"

RSpec.describe "Public job board", type: :request do
  it "lists published jobs to everyone" do
    create(:job_posting, status: :published, title: "Published Role")
    create(:job_posting, status: :draft, title: "Secret Draft")

    get jobs_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Published Role")
    expect(response.body).not_to include("Secret Draft")
  end

  it "filters by work arrangement" do
    create(:job_posting, status: :published, title: "Remote One", work_arrangement: :remote)
    create(:job_posting, status: :published, title: "Onsite One", work_arrangement: :onsite)

    get jobs_path, params: { arrangement: "remote" }
    expect(response.body).to include("Remote One")
    expect(response.body).not_to include("Onsite One")
  end

  it "searches by title" do
    create(:job_posting, status: :published, title: "Barista Wanted")
    create(:job_posting, status: :published, title: "Warehouse Crew")

    get jobs_path, params: { q: "barista" }
    expect(response.body).to include("Barista Wanted")
    expect(response.body).not_to include("Warehouse Crew")
  end

  it "shows a published posting" do
    job = create(:job_posting, status: :published)
    get job_path(job)
    expect(response).to have_http_status(:ok)
  end

  it "does not expose a non-published posting" do
    job = create(:job_posting, status: :draft)
    get job_path(job)
    expect(response).to have_http_status(:not_found)
  end
end
