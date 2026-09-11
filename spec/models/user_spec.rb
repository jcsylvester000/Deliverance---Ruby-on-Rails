require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "requires a role and an organization_type" do
    user = build(:user, role: nil, organization_type: nil)
    expect(user).not_to be_valid
    expect(user.errors.attribute_names).to include(:role, :organization_type)
  end

  it "exposes the role and organization_type enums" do
    expect(User.roles.keys).to contain_exactly("job_poster", "applicant")
    expect(User.organization_types.keys)
      .to contain_exactly("agency", "individual", "company_representative")
  end

  describe "profile creation on sign-up" do
    it "gives a job poster a poster profile" do
      user = create(:job_poster)
      expect(user.poster_profile).to be_present
      expect(user.applicant_profile).to be_nil
    end

    it "gives an applicant an applicant profile" do
      user = create(:applicant)
      expect(user.applicant_profile).to be_present
      expect(user.poster_profile).to be_nil
    end
  end
end
