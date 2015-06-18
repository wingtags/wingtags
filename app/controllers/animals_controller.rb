class AnimalsController < ApplicationController

  def index
    @animals = Animal.all.order_by(:tag_code => :asc)
  end

  def show
    @animal = Animal.find(params[:id])

    respond_to do |format|
    	format.html
    	format.json { render json: @animal }
    end
    #render json: @animal
  end

end
