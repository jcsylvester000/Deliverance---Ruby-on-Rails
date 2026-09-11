FactoryBot.define do
  factory :job_posting do
    association :poster, factory: :job_poster
    sequence(:title) { |n| "Role ##{n}" }
    description { "We need help with a thing." }
    location { "Remote" }
    employment_type { :gig }
    work_arrangement { :remote }
    status { :published }
  end
end
