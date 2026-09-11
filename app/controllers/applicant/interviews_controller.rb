module Applicant
  # Read-only calendar of the applicant's own interviews.
  class InterviewsController < BaseController
    before_action :set_interview, only: [:ics]

    def index
      @month = month_param
      @interviews = current_user.attending_interviews.where(status: :scheduled).order(:scheduled_at)
      @upcoming   = @interviews.select { |i| i.scheduled_at >= Time.current }
    end

    def ics
      send_data IcsBuilder.event(@interview),
                type: "text/calendar; charset=utf-8",
                filename: "interview-#{@interview.id}.ics"
    end

    private

    def set_interview
      @interview = current_user.attending_interviews.find(params[:id])
    end
  end
end
