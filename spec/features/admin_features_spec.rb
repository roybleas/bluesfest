require 'rails_helper'
require 'support/loginhelper'

RSpec.configure do |c|
  c.include LoginHelper
end
 
feature 'show admin' do
  background do 
    @adminuser = FactoryGirl.create(:admin_user)  
  end
  
  scenario 'as admin user' do
    user = @adminuser
    
    visit root_path
    
    click_link 'Log in'
    
    expect(current_path).to eq login_path
    fill_in "Name",             with: user.name
    fill_in "Password",         with: user.password 
    click_button 'Log in'
    expect(current_path).to eq user_path(user.id)
    
    expect(page).to have_content("Admin")
    
  end
  
  scenario 'show edit performances' do
    
    festival = create(:festival_with_stage_artist_performance)
    
    do_login(@adminuser.name, @adminuser.password)
    
    expect(page).to have_content("Admin")
     
    click_link "Edit Performances"
    
    expect(page).to have_content("Performances")
    expect(page).to have_content("Day Stage   Start Time   Performance  Duration")
    
    expect(page).to have_text("1 Mojo 19:15 KENDRICK LAMAR 60 mins")
    
  end
  
  scenario 'edit a performance' do
    festival = create(:festival_with_stage_artist_performance)
    stage = FactoryGirl.create(:stage, festival: festival, title: "Crossroads", code: "cr", seq: 2)
    show_edit_performance
    expect(page).to have_content("Performances")
    
    click_link "Edit"
    
    expect(page).to have_text("Performance: KENDRICK LAMAR")
    
    fill_in "Day", with: "4"
    fill_in "Starttime", with: "19:30:00"
    fill_in "Duration", with: "45 mins"
    select "Crossroads", :from => "performance_stage_id"
    
    click_button "Update Performance"
    
    expect(page).to have_text("4 Crossroads 19:30 KENDRICK LAMAR 45 mins")
    expect(page).to have_text("Performance updated")
    
    
  end
  scenario 'fail to edit a performance' do
    festival = create(:festival_with_stage_artist_performance)
    stage = FactoryGirl.create(:stage, festival: festival, title: "Crossroads", code: "cr", seq: 2)
    show_edit_performance
    expect(page).to have_content("Performances")
    
    click_link "Edit"
    
    expect(page).to have_text("Performance: KENDRICK LAMAR")
    
    fill_in "Day", with: "6"
    click_button "Update Performance"
    
    expect(page).to have_text("Invalid daynumber")  
    
  end
  scenario 'hide a performance' do
    festival = create(:festival_with_stage_artist_performance)
    stage = FactoryGirl.create(:stage, festival: festival, title: "Crossroads", code: "cr", seq: 2)
    artistpage = FactoryGirl.create(:artistpage, festival: festival, letterend: 'z', title: 'A-Z')
    
    visit root_path
    
    click_link "Stages"
    find('#color-mo').click_link("Day 1")
    expect(page).to have_content("19:15 KENDRICK LAMAR i (60 mins)")
    
    click_link "Artists"
    expect(page).to have_content("Kendrick Lamar")
    
    click_link "Kendrick Lamar"
    expect(page).to have_content("Kendrick Lamar")
    expect(page).to have_content("19:15 (60 mins)")
    expect(page).to have_content("Day: 1")
    
    show_edit_performance
    expect(page).to have_content("Performances")
    
    click_link "Edit"
    
    fill_in "Day", with: "-1"
    click_button "Update Performance"
    
    expect(page).to have_text("Performance updated")

    
    click_link "Stages"
    find('#color-mo').click_link("Day 1")    
    expect(page).to_not have_content("19:15 KENDRICK LAMAR i (60 mins)")
    
    click_link "Artists"
    expect(page).to have_content("Kendrick Lamar")
    
    click_link "Kendrick Lamar"
    expect(page).to have_content("Kendrick Lamar")
    expect(page).to_not have_content("19:15 (60 mins)")
    expect(page).to_not have_content("Day: -1")

  end
 
  
  def show_edit_performance
   	do_login(@adminuser.name, @adminuser.password)
    click_link "Edit Performances"
   end
end 