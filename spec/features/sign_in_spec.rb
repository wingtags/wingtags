require "rails_helper"

feature 'Signing in' do

  before :each do
    @user = User.create(FactoryGirl.attributes_for(:user))
  end

  scenario 'signs the user in successfully with a valid email and password' do 
    visit new_user_session_path
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => @user.password

    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'notifies the user if his email or password is invalid' do
    visit new_admin_animal_path

    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => 'invalid_password'

    click_button 'Log in'

    expect(page).to have_content 'Invalid email or password'
  end 

end



#describe "the signin process", :type => :feature do
#  b
#
#  it "signs me in" do
#    visit new_user_session_path
#    fill_in 'Email', :with => @user.email
#    fill_in 'Password', :with => @user.password
#
#    click_button 'Log in'
#
#    expect(page).to have_content 'Signed in successfully'
#  end
#end

#feature 'User creates a foobar' do
#  scenario 'they see the foobar on the page' do
#    visit new_foobar_path
#
#    fill_in 'Name', with: 'My foobar'
#    click_button 'Create Foobar'
#
#    expect(page).to have_css '.foobar-name', 'My foobar'
#  end
#end

#feature 'An administrator logs in' do
#  scenario 'using valid credentials' do
#    User.new(email: 'nick@wingtags.com', password: 'password')
#
#    
#  end
#end
#
#
#feature 'A simple test' do
#  scenario 'it should fail' do
#    expect(true).to eq(false)
#  end
#end