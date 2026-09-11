require "rails_helper"

RSpec.describe JobPosting, type: :model do
  it "has a valid factory" do
    expect(build(:job_posting)).to be_valid
  end

  it "requires the core fields" do
    posting = JobPosting.new
    expect(posting).not_to be_valid
    expect(posting.errors.attribute_names).to include(:title, :description)
  end

  describe "the 10 active-posting cap" do
    let(:poster) { create(:job_poster) }

    it "blocks an 11th active posting" do
      create_list(:job_posting, 10, poster: poster, status: :published)
      eleventh = build(:job_posting, poster: poster)
      expect(eleventh.valid?(:create)).to be(false)
    end

    it "frees a slot when a posting is closed" do
      create_list(:job_posting, 10, poster: poster, status: :published)
      poster.job_postings.first.update!(status: :closed)
      expect(build(:job_posting, poster: poster).valid?(:create)).to be(true)
    end

    it "counts drafts as active but not closed" do
      create_list(:job_posting, 9, poster: poster, status: :published)
      create(:job_posting, poster: poster, status: :draft)
      expect(build(:job_posting, poster: poster).valid?(:create)).to be(false)
    end
  end

  describe ".visible" do
    it "returns only published postings" do
      published = create(:job_posting, status: :published)
      create(:job_posting, status: :draft)
      create(:job_posting, status: :closed)
      expect(JobPosting.visible).to contain_exactly(published)
    end
  end

  describe "#compensation_display" do
    it "formats dollars and a period" do
      posting = build(:job_posting, compensation_cents: 12_50, compensation_period: :hourly)
      expect(posting.compensation_display).to eq("$12.50 / hr")
    end

    it "shows a dash when unset" do
      expect(build(:job_posting, compensation_cents: nil).compensation_display).to eq("—")
    end
  end

  describe "compensation_dollars=" do
    it "stores dollars as cents" do
      posting = JobPosting.new(compensation_dollars: "25.50")
      expect(posting.compensation_cents).to eq(2550)
    end
  end
end
