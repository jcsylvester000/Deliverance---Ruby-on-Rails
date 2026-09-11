module Applicant
  # Applicant uploads onboarding documents; files go to UploadThing (server-side, demo per Q2).
  class OnboardingDocumentsController < BaseController
    before_action :set_application

    def create
      unless @application.onboarding_active?
        return redirect_to applicant_applications_path, alert: "Onboarding isn't open yet."
      end

      kind = params[:kind].to_s
      unless OnboardingDocument.kinds.key?(kind)
        return redirect_to onboarding_applicant_application_path(@application), alert: "Unknown document type."
      end

      if params[:file].blank?
        return redirect_to onboarding_applicant_application_path(@application), alert: "Please choose a file to upload."
      end

      begin
        result = UploadthingService.upload(params[:file])
      rescue UploadthingService::UploadError => e
        return redirect_to onboarding_applicant_application_path(@application), alert: "Upload failed: #{e.message}"
      end

      doc = @application.onboarding_documents.find_or_initialize_by(kind: kind)
      doc.assign_attributes(
        file_url: result.url, file_key: result.key,
        file_name: result.name, byte_size: result.size, status: :uploaded
      )

      if doc.save(context: :upload)
        Notification.create!(user: @application.job_posting.poster,
                             kind: :onboarding_document_uploaded, notifiable: doc)
        redirect_to onboarding_applicant_application_path(@application), notice: "#{doc.label} uploaded."
      else
        redirect_to onboarding_applicant_application_path(@application), alert: doc.errors.full_messages.to_sentence
      end
    end

    def destroy
      doc = @application.onboarding_documents.find(params[:id])
      doc.destroy
      redirect_to onboarding_applicant_application_path(@application), notice: "Removed."
    end

    private

    def set_application
      @application = current_user.applications.find(params[:application_id])
    end
  end
end
