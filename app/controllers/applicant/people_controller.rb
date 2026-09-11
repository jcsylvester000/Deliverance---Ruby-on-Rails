module Applicant
  # Discovery: applicants find other opted-in ("discoverable") applicants to connect with.
  class PeopleController < BaseController
    def index
      @me_discoverable = current_user.applicant_profile&.discoverable?
      @people = User.applicant.where.not(id: current_user.id)
                    .joins(:applicant_profile)
                    .where(applicant_profiles: { discoverable: true })
                    .includes(:applicant_profile)

      if params[:q].present?
        term = "%#{params[:q].strip}%"
        @people = @people.where("applicant_profiles.headline ILIKE :t OR users.email ILIKE :t", t: term)
      end
    end

    # Opt in / out of being discoverable (Q1).
    def toggle
      profile = current_user.applicant_profile
      profile.update(discoverable: !profile.discoverable)
      redirect_to applicant_people_path,
                  notice: (profile.discoverable? ? "You're now discoverable to other applicants." : "You're now hidden.")
    end
  end
end
