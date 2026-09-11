FactoryBot.define do
  factory :application do
    association :applicant, factory: :applicant
    association :job_posting
    stage { :applied }
  end
end
