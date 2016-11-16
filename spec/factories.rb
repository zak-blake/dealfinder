FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "email#{n}@email.com" }
    password "password123"
    user_context :owner
  end

  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    start_time  Time.parse("10:00am")
    end_time    Time.parse("10:00pm")
    days_of_the_week 8
  end
end
