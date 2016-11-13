# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

sandbar_events = [
  ["Pint Night", "01:00", "23:00", 127, "Salvia pug locavore man bun. Next level vaporware XOXO vinyl, viral paleo echo park marfa cronut ethical iceland man braid. Direct trade hoodie helvetica pop-up green juice, af meh jianbing synth mixtape roof party pour-over blue bottle XOXO. Tbh XOXO street art tattooed air plant cornhole vexillologist, pug viral put a bird on it hella 90's."],
  ["Day Drinking", "08:00", "13:00", 96, "Synth aesthetic seitan, fixie vegan cray kickstarter meggings listicle sriracha enamel pin pour-over before they sold out bicycle rights. Unicorn VHS listicle humblebrag la croix try-hard normcore. Pabst craft beer distillery single-origin coffee authentic wolf."]
]

beach_club_events = [
  ["Beerfest", "09:00", "18:00", 127, "vaporware tousled small batch offal aesthetic single-origin coffee pickled viral venmo shoreditch cardigan. Kombucha williamsburg venmo lo-fi. Put a bird on it narwhal kickstarter occupy food truck, jean shorts fashion axe normcore DIY biodiesel vice flannel stumptown photo booth. Mixtape umami thundercats, vape pork belly synth DIY intelligentsia echo park cliche."],
  ["Stone Takeover", "16:00", "24:00", 1, "Locavore blue bottle pour-over, hammock YOLO vice bicycle rights forage 90's microdosing venmo 3 wolf moon artisan chartreuse meh."]
]

matrix_events = [
  ["Party Time", "06:00", "11:00", 48, "Drink and dance at matrix until you can't stand anymore!"]
]

donkey_bar_events = [
  ["Lunch Special", "10:00", "13:00", 31, "Two for one lunch items and free apps with purchase of drink"]
]

user_list = [
  [ "sandbar@gmail.com",    "Sandbar",             "password", 0, sandbar_events, "Salvia pug locavore man bun. Next level vaporware XOXO vinyl, viral paleo echo park marfa cronut ethical iceland man braid. Direct trade hoodie helvetica pop-up green juice, af meh jianbing synth mixtape roof party pour-over blue bottle XOXO. Tbh XOXO street art tattooed air plant cornhole vexillologist, pug viral put a bird on it hella 90's."],
  [ "seven@gmail.com",      "Seven",                "password", 0, nil, "Synth aesthetic seitan, fixie vegan cray kickstarter meggings listicle sriracha enamel pin pour-over before they sold out bicycle rights."],
  [ "beachclub@gmail.com",  "Beach Club",           "password", 0, beach_club_events, "Locavore blue bottle pour-over, hammock YOLO vice bicycle rights forage 90's microdosing venmo 3 wolf moon artisan chartreuse meh."],
  [ "admin@gmail.com",      "Matrix",               "password", 0, matrix_events, "Kombucha williamsburg venmo lo-fi. Put a bird on it narwhal kickstarter occupy food truck, jean shorts fashion axe normcore DIY biodiesel"],
  [ "donkey@gmail.com",     "Drunken Donkey",       "password", 0, donkey_bar_events, "Put a bird on it narwhal kickstarter occupy food truck, jean shorts fashion axe normcore DIY biodiesel vice flannel stumptown photo booth. Mixtape umami thundercats, vape pork belly synth DIY intelligentsia echo park cliche."],
  [ "arie@gmail.com",       "Arie Allen",           "password", 1],
  [ "zak@gmail.com",        "Zak Blake",            "password", 1]
]



user_list.each do |email, name, password, user_context, events, desc|
  puts "Creating User: " + name.to_s
  u = User.create(
    name: name,
    description: desc,
    password: password,
    email: email,
    user_context: user_context )

  events.each do |name, start_time, end_time, days, desc|
    puts "Creating Event: " + name.to_s
    Event.create(
      user_id: u.id,
      days_of_the_week: days,
      name: name,
      start_time: start_time,
      end_time: end_time,
      description: desc
    )
  end unless u.admin? || events.nil?
end
