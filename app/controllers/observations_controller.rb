class ObservationsController < ApplicationController
  def index
    @observations = Observation.order_by(:observed_at, :desc).limit(10).to_a
  end
end
