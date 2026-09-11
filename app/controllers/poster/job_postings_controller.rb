module Poster
  # Poster-owned postings. Every query is scoped to current_user.job_postings, so a poster
  # can only ever see or touch their own — index and show included.
  class JobPostingsController < BaseController
    before_action :set_job_posting, only: [:edit, :update, :close, :destroy]

    def index
      @job_postings = current_user.job_postings.recent
      @active_count = current_user.job_postings.where(status: JobPosting::ACTIVE_STATUSES).count
    end

    def new
      @job_posting = current_user.job_postings.new(status: :draft)
    end

    def create
      @job_posting = current_user.job_postings.new(job_posting_params)
      if @job_posting.save
        redirect_to poster_job_postings_path, notice: "Job posting created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit; end

    def update
      if @job_posting.update(job_posting_params)
        redirect_to poster_job_postings_path, notice: "Job posting updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def close
      @job_posting.update(status: :closed)
      redirect_to poster_job_postings_path, notice: "Job posting closed — a slot is free again."
    end

    def destroy
      @job_posting.destroy
      redirect_to poster_job_postings_path, notice: "Job posting deleted."
    end

    private

    def set_job_posting
      @job_posting = current_user.job_postings.find(params[:id])
    end

    def job_posting_params
      params.require(:job_posting).permit(
        :title, :description, :location,
        :employment_type, :work_arrangement, :status,
        :compensation_dollars, :compensation_period
      )
    end
  end
end
