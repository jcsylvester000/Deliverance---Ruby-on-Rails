require "rails_helper"

RSpec.describe "Notifications", type: :request do
  it "lists the user's notifications and marks them read" do
    poster = create(:job_poster)
    job = create(:job_posting, poster: poster)
    app = create(:application, job_posting: job)
    app.notify_applied!

    sign_in poster
    expect(poster.notifications.unread.count).to eq(1)

    get notifications_path
    expect(response).to have_http_status(:ok)
    expect(poster.notifications.unread.count).to eq(0)
  end
end
