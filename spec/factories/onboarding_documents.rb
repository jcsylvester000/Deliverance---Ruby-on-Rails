FactoryBot.define do
  factory :onboarding_document do
    association :application, factory: :application
    kind { :id_photo }
    status { :uploaded }
    file_url { "https://demo.ufs.sh/f/demo-key" }
    file_key { "demo-key" }
    file_name { "sample.txt" }
    byte_size { 1024 }
  end
end
