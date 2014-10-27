class Admin::AnimalsController < ApplicationController

  before_action :verify_admin

  def index
    @animals = Animal.all.order_by(:created_at).to_a
  end

  def new
    @animal = Animal.new
  end

  def create
    @animal = Animal.new(params[:animal])

    respond_to do |format|
      if @animal.save 
        format.html { redirect_to admin_animals_url, notice: "#{@animal.name} was successfully created!" }
      else 
        format.html { render action: "new" }
      end
    end
  end

  def update
    animal = Animal.find(params[:id])
    animal.update_attributes(params[:animal])
    redirect_to admin_animals_url, notice: "#{animal.name} was successfully updated."
  end

  def show
    @animal = Animal.find(params[:id])
 
    respond_to do |format|
      format.html
    end
  end

  def edit
    @animal = Animal.find(params[:id])
  end

  def verify_admin
    authorize :admin
  end
end
