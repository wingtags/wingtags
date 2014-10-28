class Observation
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  store_in :database => ENV['RETHINKDB_DB'], :table => 'Sighting'

  field :id,          :type => String,      :as => 'SightingID',   :primary_key => true
  field :created_at,  :type => Time,        :as => 'CreatedDate'
  field :updated_at,  :type => Time,        :as => 'UpdatedDate'
  field :observed_at, :type => Time,        :as => 'SightingDate'
  field :latitude,    :type => Float,       :as => 'Latitude'
  field :longitude,   :type => Float,       :as => 'Longitude'
  field :address,     :type => String,      :as => 'Location'
  field :image,       :type => String,      :as => 'ImageURL'
  field :animal_id,   :type => String,      :as => 'WildlifeID'

end
