FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "email#{n}@email.com" }
    password "password123"
    user_context :owner
  end

  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    start_time  "12:00"
    end_time    "01:00"
    days_of_the_week 8
  end
end
