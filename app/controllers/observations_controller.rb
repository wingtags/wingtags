class ObservationsController < ApplicationController
  def index
    @observations = Observation.order_by(:observed_at => :desc).limit(100).to_a
    @observations.each do |o|
      o.image ? o.image = 'https://wingtags-syd.s3.amazonaws.com/images/s/' + o.image : ''
    end
  end

  def new
  end
end
