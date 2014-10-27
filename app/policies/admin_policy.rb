class AdminPolicy < Struct.new(:user, :dashboard)
  def initialize(user, dashboard)
    @user = user
    @dashboard = dashboard
  end

  def show?
    @user.role == 'Admin'
  end
end