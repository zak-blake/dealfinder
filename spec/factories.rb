FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "email#{n}@email.com" }
    created_at "2016-11-16 07:19:27"
    updated_at "2016-11-16 07:19:27"
    password "password123"
    user_context :owner
  end

  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    created_at "2016-11-16 07:19:27"
    updated_at "2016-11-16 07:19:27"
    start_time  Time.parse("10:00am")
    end_time    Time.parse("10:00pm")
    days_of_the_week 8
  end
end
