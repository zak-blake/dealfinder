# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_list = [
  [ "sandbar@gmail.com",     "Sandbar",              "password", 0, "Salvia pug locavore man bun. Next level vaporware XOXO vinyl, viral paleo echo park marfa cronut ethical iceland man braid. Direct trade hoodie helvetica pop-up green juice, af meh jianbing synth mixtape roof party pour-over blue bottle XOXO. Tbh XOXO street art tattooed air plant cornhole vexillologist, pug viral put a bird on it hella 90's."],
  [ "seven@gmail.com",      "Seven",                "password", 0, "Synth aesthetic seitan, fixie vegan cray kickstarter meggings listicle sriracha enamel pin pour-over before they sold out bicycle rights."],
  [ "beachclub@gmail.com",  "Beach Club",           "password", 0, "Locavore blue bottle pour-over, hammock YOLO vice bicycle rights forage 90's microdosing venmo 3 wolf moon artisan chartreuse meh."],
  [ "admin@gmail.com",      "Matrix Bar and Club",  "password", 0, "Kombucha williamsburg venmo lo-fi. Put a bird on it narwhal kickstarter occupy food truck, jean shorts fashion axe normcore DIY biodiesel"],
  [ "donkey@gmail.com",     "Donkey Bar and Grill", "password", 0, " Put a bird on it narwhal kickstarter occupy food truck, jean shorts fashion axe normcore DIY biodiesel vice flannel stumptown photo booth. Mixtape umami thundercats, vape pork belly synth DIY intelligentsia echo park cliche."],
  [ "arie@gmail.com",       "Arie Allen",           "password", 1],
  [ "zak@gmail.com",        "Zak Blake",            "password", 1]
]

event_list = [
  ["Pint Night", "7:00pm", "11:00pm", "Salvia pug locavore man bun. Next level vaporware XOXO vinyl, viral paleo echo park marfa cronut ethical iceland man braid. Direct trade hoodie helvetica pop-up green juice, af meh jianbing synth mixtape roof party pour-over blue bottle XOXO. Tbh XOXO street art tattooed air plant cornhole vexillologist, pug viral put a bird on it hella 90's."],
  ["Day Drinking", "10:00am", "04:00pm", "Synth aesthetic seitan, fixie vegan cray kickstarter meggings listicle sriracha enamel pin pour-over before they sold out bicycle rights. Unicorn VHS listicle humblebrag la croix try-hard normcore. Pabst craft beer distillery single-origin coffee authentic wolf."],
  ["Dog Day", "10:00am", "12:00pm", "Mlkshk kombucha post-ironic edison bulb, blog keytar occupy vice pork belly stumptown. Flannel vegan readymade, 8-bit artisan four loko echo park tilde actually street art vinyl air plant lomo green juice. Photo booth poutine kombucha farm-to-table. Bitters intelligentsia stumptown"],
  ["Beerfest", "9:00am", "6:00pm", "vaporware tousled small batch offal aesthetic single-origin coffee pickled viral venmo shoreditch cardigan. Kombucha williamsburg venmo lo-fi. Put a bird on it narwhal kickstarter occupy food truck, jean shorts fashion axe normcore DIY biodiesel vice flannel stumptown photo booth. Mixtape umami thundercats, vape pork belly synth DIY intelligentsia echo park cliche."],
  ["Stone Takeover", "4:00pm", "12:00pm", "Locavore blue bottle pour-over, hammock YOLO vice bicycle rights forage 90's microdosing venmo 3 wolf moon artisan chartreuse meh."]
]


user_list.each do |email, name, password, user_context, desc|
  puts "Creating User: " + name.to_s
  u = User.create(
    name: name,
    description: desc,
    password: password,
    email: email,
    user_context: user_context )

  event_list.each do |name, start_time, end_time, desc|
    puts "Creating Event: " + name.to_s
    Event.create(
      user_id: u.id,
      name: name,
      start_time: start_time,
      end_time: end_time,
      description: desc
    )
  end unless u.admin?
end
