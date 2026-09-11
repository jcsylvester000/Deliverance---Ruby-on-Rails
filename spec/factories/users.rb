FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@deliverance.test" }
    password { "password123" }
    organization_type { :individual }
    role { :applicant }

    factory :job_poster do
      role { :job_poster }
      organization_type { :company_representative }
    end

    factory :applicant do
      role { :applicant }
      organization_type { :individual }
    end
  end
end
