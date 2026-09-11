require "rails_helper"

RSpec.describe Interview, type: :model do
  it "has a valid factory" do
    expect(build(:interview)).to be_valid
  end

  it "requires a scheduled_at" do
    expect(build(:interview, scheduled_at: nil)).not_to be_valid
  end

  it "computes ends_at from the duration" do
    iv = build(:interview, scheduled_at: Time.zone.local(2026, 9, 20, 10, 0), duration_minutes: 45)
    expect(iv.ends_at).to eq(Time.zone.local(2026, 9, 20, 10, 45))
  end

  it "notifies the applicant when scheduled" do
    iv = create(:interview)
    expect { iv.notify_scheduled! }.to change(iv.applicant.notifications, :count).by(1)
  end

  it "reaches the applicant and job posting through its application" do
    iv = create(:interview)
    expect(iv.applicant).to eq(iv.application.applicant)
    expect(iv.job_posting).to eq(iv.application.job_posting)
  end
end
