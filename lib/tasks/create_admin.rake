namespace :db do
  task create_admins: :environment do
    User.where(user_context: :admin).delete_all

    [
      [ "arie@gmail.com",      "arie allen", "password123!", 1],
      [ "94zakary@gmail.com",  "zak blake",  "password123!", 1]
    ].each do |email, user_name, password, user_context|
      User.create(
        name: user_name,
        password: password,
        email: email,
        user_context: user_context
      )
    end
  end
end
