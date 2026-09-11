require "rails_helper"

RSpec.describe Application, type: :model do
  it "has a valid factory" do
    expect(build(:application)).to be_valid
  end

  it "cannot be created against an unpublished role" do
    draft = create(:job_posting, status: :draft)
    app = build(:application, job_posting: draft)
    expect(app.valid?(:create)).to be(false)
  end

  describe "the 20 active-application cap" do
    let(:applicant) { create(:applicant) }

    it "blocks a 21st active application" do
      create_list(:application, 20, applicant: applicant)
      expect(build(:application, applicant: applicant).valid?(:create)).to be(false)
    end

    it "frees a slot after a withdrawal" do
      apps = create_list(:application, 20, applicant: applicant)
      apps.first.withdraw!
      expect(build(:application, applicant: applicant).valid?(:create)).to be(true)
    end
  end

  describe "duplicate applications" do
    let(:applicant) { create(:applicant) }
    let(:job) { create(:job_posting) }

    it "blocks a second active application to the same role" do
      create(:application, applicant: applicant, job_posting: job)
      dup = build(:application, applicant: applicant, job_posting: job)
      expect(dup.valid?(:create)).to be(false)
    end

    it "allows re-applying after withdrawing" do
      first = create(:application, applicant: applicant, job_posting: job)
      first.withdraw!
      again = build(:application, applicant: applicant, job_posting: job)
      expect(again.valid?(:create)).to be(true)
    end
  end

  describe "#advance!" do
    it "moves to the next stage and notifies the applicant" do
      app = create(:application, stage: :applied)
      expect { app.advance! }
        .to change { app.reload.stage }.from("applied").to("under_review")
        .and change(Notification, :count).by(1)
    end

    it "stops at the final stage" do
      app = create(:application, stage: :hired)
      expect(app.advance!).to be(false)
    end
  end

  describe "#reject! and #withdraw!" do
    it "rejects and notifies the applicant" do
      app = create(:application)
      app.reject!
      expect(app.reload).to be_rejected
    end

    it "withdraws and notifies the poster" do
      app = create(:application)
      expect { app.withdraw! }.to change { app.job_posting.poster.notifications.count }.by(1)
      expect(app.reload).to be_withdrawn
    end
  end
end
