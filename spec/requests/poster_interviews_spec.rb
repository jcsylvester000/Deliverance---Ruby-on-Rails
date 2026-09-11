require "rails_helper"

RSpec.describe "Poster interviews", type: :request do
  let(:poster) { create(:job_poster) }
  let(:job) { create(:job_posting, poster: poster, status: :published) }
  let(:application) { create(:application, job_posting: job, stage: :under_review) }

  before { sign_in poster }

  it "schedules an interview, moves the stage, and notifies the applicant" do
    expect {
      post poster_interviews_path, params: {
        application_id: application.id,
        interview: {
          scheduled_at: 2.days.from_now.change(sec: 0).strftime("%Y-%m-%dT%H:%M"),
          duration_minutes: 30, mode: "online", meeting_link: "https://x.test/a"
        }
      }
    }.to change(Interview, :count).by(1)
      .and change(application.applicant.notifications, :count).by(1)

    expect(application.reload.stage).to eq("interview")
    expect(response).to redirect_to(poster_interviews_path)
  end

  it "cancels an interview and notifies the applicant" do
    iv = create(:interview, application: application)
    expect {
      patch cancel_poster_interview_path(iv)
    }.to change(application.applicant.notifications, :count).by(1)
    expect(iv.reload).to be_cancelled
  end

  it "downloads an .ics file" do
    iv = create(:interview, application: application)
    get ics_poster_interview_path(iv)
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("text/calendar")
    expect(response.body).to include("BEGIN:VCALENDAR")
  end

  it "cannot schedule against another poster's application" do
    other_app = create(:application)
    post poster_interviews_path, params: {
      application_id: other_app.id,
      interview: { scheduled_at: 1.day.from_now.strftime("%Y-%m-%dT%H:%M"), duration_minutes: 30, mode: "online" }
    }
    expect(response).to have_http_status(:not_found)
  end
end
