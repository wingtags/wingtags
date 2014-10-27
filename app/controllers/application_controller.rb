class ApplicationController < ActionController::Base
  # Control user authorization using Pundit
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
