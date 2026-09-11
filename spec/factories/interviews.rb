FactoryBot.define do
  factory :interview do
    association :application, factory: :application
    scheduled_at { 2.days.from_now.change(sec: 0) }
    duration_minutes { 30 }
    mode { :online }
    meeting_link { "https://meet.example.com/demo" }
    status { :scheduled }
  end
end
