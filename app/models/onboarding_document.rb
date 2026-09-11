class OnboardingDocument < ApplicationRecord
  # DEMO / PROTOTYPE (per Q2): not real government-ID storage. Files are hosted on UploadThing;
  # we store the returned URL + key here (the secret token never leaves the server).
  belongs_to :application

  enum :kind,   { id_photo: 0, resume: 1, other: 2 }
  enum :status, { requested: 0, uploaded: 1 }

  delegate :applicant, :job_posting, to: :application

  CHECKLIST = [
    { kind: "id_photo", label: "Photo ID (demo — any picture)", required: true },
    { kind: "resume",   label: "Résumé / CV",                   required: false }
  ].freeze

  validates :file_url, presence: true, on: :upload

  def poster
    job_posting.poster
  end

  def attached?
    file_url.present?
  end

  def label
    CHECKLIST.find { |c| c[:kind] == kind }&.dig(:label) || kind.to_s.humanize
  end
end
