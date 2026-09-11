require "rails_helper"

RSpec.describe "Applicant interviews", type: :request do
  it "shows only the applicant's own interviews" do
    applicant = create(:applicant)
    mine = create(:interview, application: create(:application, applicant: applicant))
    create(:interview) # someone else's

    sign_in applicant
    get applicant_interviews_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(mine.job_posting.title)
  end

  it "cannot download another applicant's .ics" do
    sign_in create(:applicant)
    other = create(:interview)
    get ics_applicant_interview_path(other)
    expect(response).to have_http_status(:not_found)
  end
end
