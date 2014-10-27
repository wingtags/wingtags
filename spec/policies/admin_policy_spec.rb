#describe AdminPolicy do
#  subject { AdminPolicy.new(user, record) }
#
#  let (:record) { Object.new }
#
#  context "for a visitor" do
#    let (:user) { FactoryGirl.build :visitor }
#
#    it { should_not permit(:index)    }
#    it { should_not permit(:show)     }
#    it { should_not permit(:new)      }
#    it { should_not permit(:create)   }
#    it { should_not permit(:update)   }
#    it { should_not permit(:edit)     }
#    it { should_not permit(:destroy)  }
#  end
#
#  context "for a user" do
#    let (:user) { FactoryGirl.build :user }
#
#    it { should_not permit(:index)    }
#    it { should_not permit(:show)     }
#    it { should_not permit(:new)      }
#    it { should_not permit(:create)   }
#    it { should_not permit(:update)   }
#    it { should_not permit(:edit)     }
#    it { should_not permit(:destroy)  }
#  end
#
#  context "for an admin" do
#    let (:user) { FactoryGirl.build :admin }
#
#    it { should permit(:index)    }
#    it { should permit(:show)     }
#    it { should permit(:new)      }
#    it { should permit(:create)   }
#    it { should permit(:update)   }
#    it { should permit(:edit)     }
#    it { should permit(:destroy)  }
#  end
#end