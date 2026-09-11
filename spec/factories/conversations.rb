FactoryBot.define do
  factory :conversation do
    association :creator, factory: :applicant
    kind { :direct }
  end
end
