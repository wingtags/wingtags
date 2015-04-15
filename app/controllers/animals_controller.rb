class AnimalsController < ApplicationController

  def show
    @animal = Animal.find(params[:id])
    render json: @animal
  end

end
