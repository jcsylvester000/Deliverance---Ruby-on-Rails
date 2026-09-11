require "rails_helper"

RSpec.describe "Applicant onboarding", type: :request do
  let(:applicant) { create(:applicant) }
  let(:job) { create(:job_posting, status: :published) }
  let!(:application) { create(:application, applicant: applicant, job_posting: job, stage: :onboarding) }

  before do
    sign_in applicant
    # Stub the UploadThing call so the suite never hits the network / Node.
    allow(UploadthingService).to receive(:upload).and_return(
      UploadthingService::Result.new(key: "k1", url: "https://demo.ufs.sh/f/k1", name: "id.txt", size: 12)
    )
  end

  it "shows the onboarding checklist once at that stage" do
    get onboarding_applicant_application_path(application)
    expect(response).to have_http_status(:ok)
  end

  it "uploads a document via UploadThing and notifies the poster" do
    upload = fixture_file_upload("sample.txt", "text/plain")
    expect {
      post applicant_application_onboarding_documents_path(application),
           params: { kind: "id_photo", file: upload }
    }.to change(OnboardingDocument, :count).by(1)
      .and change(job.poster.notifications, :count).by(1)

    doc = application.onboarding_documents.first
    expect(doc.file_url).to eq("https://demo.ufs.sh/f/k1")
    expect(doc).to be_uploaded
  end

  it "blocks onboarding for an application not at that stage" do
    other = create(:application, applicant: applicant, stage: :applied)
    get onboarding_applicant_application_path(other)
    expect(response).to redirect_to(applicant_applications_path)
  end

  it "cannot open another applicant's onboarding" do
    theirs = create(:application, stage: :onboarding)
    get onboarding_applicant_application_path(theirs)
    expect(response).to have_http_status(:not_found)
  end
end
