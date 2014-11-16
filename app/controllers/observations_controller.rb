class ObservationsController < ApplicationController

  protect_from_forgery with: :null_session
  respond_to :json

	#wrap_parameters format: [:json, :xml]

  def index
    @observations = Observation.order_by(:observed_at => :desc).limit(100).to_a
    @observations.each do |o|
      o.image ? o.image = 'https://wingtags-syd.s3.amazonaws.com/images/s/' + o.image : ''
    end
  end

  def new
    @form_data = ObservationForm.new
  end

  def create
    binding.pry
    @form_data = ObservationForm.new(params['observation'])
    @form_data.save
    respond_with @form_data.observation
  end
end
