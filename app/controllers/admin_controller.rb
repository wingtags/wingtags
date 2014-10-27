class AdminController < ApplicationController
  def index
    
  end
  def show
    authorize :admin
  end
end
