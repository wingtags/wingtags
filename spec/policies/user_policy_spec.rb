#require '../../app/models/user'
#require "pundit/rspec"

describe UserPolicy do
  subject { UserPolicy.new(user, record) }

  let (:record) { FactoryGirl.build :user }

  context "for a visitor" do
    let (:user) { FactoryGirl.build_stubbed :visitor }

    it { should_not permit(:index)    }
    it { should_not permit(:show)     }
    it { should_not permit(:new)      }
    it { should_not permit(:create)   }
    it { should_not permit(:update)   }
    it { should_not permit(:edit)     }
    it { should_not permit(:destroy)  }
  end

  context "for a user" do
    let (:user) { FactoryGirl.build :user }

    # permit show
    # permit edit
    # permit update
  end

  #permissions :index? do
  #  it "denies access if not an admin" do
  #    expect(UserPolicy).not_to permit(current_user)
  #  end
#
  #  #it "allows access for an admin" do
  #  #  expect(UserPolicy).to permit(admin)
  #  #end
  #end
#
  #permissions :show? do
  #  it "prevents other users from seeing your profile" do
  #    expect(subject).not_to permit(current_user, other_user)
  #  end
  #  it "allows you to see your own profile" do
  #    expect(subject).to permit(current_user, current_user)
  #  end
  #  it "allows an admin to see any profile" do
  #    expect(subject).to permit(admin)
  #  end
  #end
#
  #permissions :update? do
  #  it "prevents updates if not an admin" do
  #    expect(subject).not_to permit(current_user)
  #  end
  #  it "allows an admin to make updates" do
  #    expect(subject).to permit(admin)
  #  end
  #end
#
  #permissions :destroy? do
  #  it "prevents deleting yourself" do
  #    expect(subject).not_to permit(current_user, current_user)
  #  end
  #  it "allows an admin to delete any user" do
  #    expect(subject).to permit(admin, other_user)
  #  end
  #end

end