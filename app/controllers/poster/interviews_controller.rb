module Poster
  # Poster schedules, reschedules, and cancels interviews for their own applications.
  class InterviewsController < BaseController
    before_action :set_interview,     only: [:edit, :update, :cancel, :ics]
    before_action :set_application,   only: [:new, :create]

    def index
      @month = month_param
      @interviews = current_user.hosted_interviews.where(status: :scheduled).order(:scheduled_at)
      @upcoming   = @interviews.select { |i| i.scheduled_at >= Time.current }
    end

    def new
      redirect_to(edit_poster_interview_path(@application.interview), notice: "This applicant already has an interview.") and return if @application.interview

      @interview = @application.build_interview(scheduled_at: 1.day.from_now.change(hour: 10), mode: :online)
    end

    def create
      @interview = @application.build_interview(interview_params)
      if @interview.save
        @application.ensure_at_least_interview!
        @interview.notify_scheduled!
        redirect_to poster_interviews_path, notice: "Interview scheduled."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit; end

    def update
      if @interview.update(interview_params.merge(status: :scheduled))
        @interview.notify_scheduled!
        redirect_to poster_interviews_path, notice: "Interview updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def cancel
      @interview.update!(status: :cancelled)
      @interview.notify_cancelled!
      redirect_to poster_interviews_path, notice: "Interview cancelled."
    end

    def ics
      send_data IcsBuilder.event(@interview),
                type: "text/calendar; charset=utf-8",
                filename: "interview-#{@interview.id}.ics"
    end

    private

    def set_application
      @application = current_user.received_applications.find(params[:application_id])
    end

    def set_interview
      @interview = current_user.hosted_interviews.find(params[:id])
    end

    def interview_params
      params.require(:interview).permit(:scheduled_at, :duration_minutes, :mode, :meeting_link, :location, :notes)
    end
  end
end
