# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name:  "Roy Admin User",
             screen_name: "Admin Roy",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)
User.create(name:  "Roy User",
             screen_name: "Roy",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: false)