require 'rails_helper'

feature 'Administration' do
  before :each do
    @user = FactoryGirl.create(:admin)
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
  end

  scenario 'Administrator should see admin link on successful login' do
    expect(current_path).to eq(root_path)
    expect(page).to have_content('Admin')
  end

  scenario 'Administrator creates an animal' do
    visit new_admin_animal_path
    
  end
end
#describe 'animal management' do
#  before :each do 
#    
#  end
#
#  it 'adds an animal' do
#    click_link 'Manage Animals'
#    current_path.should eq admin_animals_path
#  end
#end