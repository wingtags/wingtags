class UserPolicy < ApplicationPolicy
  def show?
    ['User', 'Admin'].include? @user.role
  end
end