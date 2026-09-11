require "rails_helper"

RSpec.describe "Applicant discovery", type: :request do
  it "lists only discoverable applicants" do
    me = create(:applicant)
    sign_in me

    findable = create(:applicant)
    findable.applicant_profile.update!(discoverable: true, headline: "Findable Person")
    hidden = create(:applicant)
    hidden.applicant_profile.update!(discoverable: false, headline: "Hidden One")

    get applicant_people_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Findable Person")
    expect(response.body).not_to include("Hidden One")
  end

  it "toggles the applicant's own discoverability" do
    me = create(:applicant)
    sign_in me
    expect {
      patch applicant_toggle_discovery_path
    }.to change { me.applicant_profile.reload.discoverable }.from(false).to(true)
  end
end
