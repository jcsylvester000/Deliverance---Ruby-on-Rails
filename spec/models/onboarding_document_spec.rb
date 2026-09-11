require "rails_helper"

RSpec.describe OnboardingDocument, type: :model do
  it "reaches the applicant and job posting through its application" do
    doc = create(:onboarding_document)
    expect(doc.applicant).to eq(doc.application.applicant)
    expect(doc.job_posting).to eq(doc.application.job_posting)
  end

  it "requires a file_url in the :upload context" do
    expect(build(:onboarding_document, file_url: nil).valid?(:upload)).to be(false)
  end

  it "reports outstanding required items on the application" do
    app = create(:application, stage: :onboarding)
    expect(app.onboarding_outstanding.map { |c| c[:kind] }).to include("id_photo")
    expect(app.onboarding_complete?).to be(false)

    create(:onboarding_document, application: app, kind: :id_photo)
    expect(app.reload.onboarding_complete?).to be(true)
  end
end
