#feature 'Sign in', :type => :controller do 
#  scenario 'user can sign in with valid credentials' do
#    user = User.create(FactoryGirl.attributes_for(:user))
#
#    sign_in user
#
#    expect(page).to have_content I18n.t 'devise.sessions.signed_in'
#  end
#end