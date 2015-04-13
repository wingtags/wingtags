class ObservationsController < ApplicationController

  protect_from_forgery with: :null_session

	#wrap_parameters format: [:json, :xml]

  def index
    @observations = Observation.order_by(:observed_at => :desc).limit(100).to_a
    @observations.each do |o|
      o.image ? o.image = 'https://wingtags-syd.s3.amazonaws.com/images/s/' + o.image : ''
    end
  end

  def new
    #@form_data = ObservationForm.new
  end

  def create
    form = ObservationForm.new(params['observation'])
    observation = form.to_observation
    if observation.save?
      puts 'saved'
      render json: observation
    else
      puts 'not saved'
      render json: {}
    end
  end
end
