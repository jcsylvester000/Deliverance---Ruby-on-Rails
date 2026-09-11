require "rails_helper"

RSpec.describe Notification, type: :model do
  it "creates and broadcasts on arrival without error" do
    poster = create(:job_poster)
    job = create(:job_posting, poster: poster)
    application = create(:application, job_posting: job)

    expect { application.notify_applied! }.to change(poster.notifications, :count).by(1)
  end

  it "maps each kind to an icon" do
    expect(Notification.new(kind: :message_request).icon).to eq("💬")
    expect(Notification.new(kind: :interview_scheduled).icon).to eq("📅")
    expect(Notification.new(kind: :application_received).icon).to eq("📥")
  end
end
