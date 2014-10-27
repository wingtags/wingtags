describe "animals/edit" do
  before(:each) do
    user = assign(:user, build_stubbed(:admin))
    animal = assign(:animal, build(:animal))
    controller.stub(:current_user).and_return user
  end

  context 'when the user is an admin' do
    #it 'displays the edit action' do
    #  allow(view).to receive(:policy).and_return double(edit?: true)
#
    #  render
#
    #  expect(rendered).to have_content 'Edit'
    #end
  end

  #it "renders the destroy action" do
  #  allow(view).to receive(:policy).and_return double(edit?: false, destroy?: true)
#
  #  render
  #  expect(rendered).to match 'Destroy'
  #end
end