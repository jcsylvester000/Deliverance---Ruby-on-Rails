# Public job board — browsing is open to everyone; applying (Phase 3) requires an account.
class JobsController < ApplicationController
  def index
    @jobs = JobPosting.visible.recent.includes(poster: :poster_profile)

    if JobPosting.work_arrangements.key?(params[:arrangement])
      @jobs = @jobs.where(work_arrangement: params[:arrangement])
      @arrangement = params[:arrangement]
    end

    if JobPosting.employment_types.key?(params[:employment_type])
      @jobs = @jobs.where(employment_type: params[:employment_type])
      @employment_type = params[:employment_type]
    end

    if params[:q].present?
      @q = params[:q].strip
      term = "%#{@q}%"
      @jobs = @jobs.where("title ILIKE :t OR description ILIKE :t OR location ILIKE :t", t: term)
    end
  end

  def show
    # Only published postings are ever public.
    @job = JobPosting.visible.find(params[:id])
  end
end
