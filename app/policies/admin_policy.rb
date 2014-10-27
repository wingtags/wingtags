class AdminPolicy < Struct.new(:user, :record)
  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "user must be an administrator" unless user && user.role == 'Admin'
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    true
  end
end