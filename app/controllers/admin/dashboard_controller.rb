class Admin::DashboardController < ApplicationController

  before_action :verify_admin

  def index
    #authorize :admin
  end

  def verify_admin
    authorize :admin
  end
end
