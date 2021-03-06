class ObservationsController < ApplicationController

  protect_from_forgery with: :null_session

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
    form = ObservationForm.new(observation_params)
    observation = form.to_observation
    if observation.save?
      render json: observation
    else
      render json: {}
    end
  end

  def show
    @observation = Observation.find(params[:id])
  end

  private

  def observation_params
    {  
      :address        => params[:address],
      :tag            => params[:tag].to_i,
      :latitude       => params[:latitude].to_f,
      :longitude      => params[:longitude].to_f,
      :timestamp      => params[:timestamp].to_f,
      :user_id        => params[:user_id],
      :user_email     => params[:user_email],
      :image          => params[:image],
      :termscondition => params[:termscondition]
    }
  end
end
