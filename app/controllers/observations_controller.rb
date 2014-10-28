class ObservationsController < ApplicationController
  def index
    @observations = Observation.order_by(:observed_at => :desc).limit(30).to_a
    @observations.each do |o|
      o.image ? o.image = 'https://wingtags-syd.s3.amazonaws.com/images/s/' + o.image : ''
    end
  end
end
