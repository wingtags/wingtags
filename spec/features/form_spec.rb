require "rails_helper"

feature 'Form submit' do

  before :each do
    Capybara.current_driver = :selenium
    @user = User.create(FactoryGirl.attributes_for(:user))
  end

  scenario 'Anonymous user fills in the form', js: true do
    visit "/observations/new"
    #page.execute_script("$(function() { App.router = new App.Router(); Backbone.history.start(); });")
    #accept_alert do
    #  save_and_open_screenshot
    #end
    #within('#app-container#') do
    page.should have_content('Our aim is to assess ') 
    #accept_prompt do
    #  visit new_observation_path
    #  fill_in 'Tag number', :with => 22
    #end
    #fill_in 'Password', :with => @user.password
#
    #click_button 'Log in'
#
    #expect(page).to have_content 'Signed in successfully'
  end
end