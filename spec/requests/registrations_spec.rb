require "rails_helper"

RSpec.describe "Registration via the get-to-know-you modal", type: :request do
  it "creates a job poster with a profile and sends them to the HUD" do
    expect {
      post user_registration_path, params: { user: {
        role: "job_poster",
        organization_type: "company_representative",
        heard_from: "Social media",
        email: "new-poster@deliverance.test",
        password: "password123",
        password_confirmation: "password123"
      } }
    }.to change(User, :count).by(1)

    user = User.find_by(email: "new-poster@deliverance.test")
    expect(user).to be_job_poster
    expect(user.poster_profile).to be_present
    expect(response).to redirect_to(setting_up_path)
  end

  it "creates an applicant without requiring the optional question" do
    expect {
      post user_registration_path, params: { user: {
        role: "applicant",
        organization_type: "individual",
        heard_from: "",
        email: "new-applicant@deliverance.test",
        password: "password123",
        password_confirmation: "password123"
      } }
    }.to change(User, :count).by(1)

    expect(User.last.applicant_profile).to be_present
    expect(response).to redirect_to(setting_up_path)
  end
end
