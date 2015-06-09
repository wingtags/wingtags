class AnimalsController < ApplicationController

  def index
    @animals = Animal.all.order_by(:tag_code => :asc)
  end

  def show
    @animal = Animal.find(params[:id])
    #render json: @animal
  end

end
