FactoryGirl.define do
  factory :example do
    foo { Faker::Lorem.word }
    bar { Faker::Lorem.word }
    baz { Faker::Lorem.word }
  end
end
