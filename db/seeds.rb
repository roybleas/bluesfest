User.create(name:  "Roy Admin User",
             screen_name: "Admin Roy",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             tester: false)
User.create(name:  "Roy User",
             screen_name: "Roy",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: false,
             tester: false)
             
User.create(name:  "Roy Tester User",
             screen_name: "Tester Roy",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: false,
             tester: true)