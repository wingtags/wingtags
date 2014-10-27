class AnimalPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    @user.role == 'Admin'
  end

  def create?
    @user.role == 'Admin'
  end

  def update?
    @user.role == 'Admin'
  end

  def destroy?
    @user.role == 'Admin'
  end
end