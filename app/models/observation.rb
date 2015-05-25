class Observation
  extend Dragonfly::Model
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  dragonfly_accessor :image do
    storage_options do |img|
      { path: "#{image_uuid}.#{image_format}" }
    end
  end
  
  store_in :database => ENV['RETHINKDB_DB'], :table => 'Sighting'

  belongs_to :user
  belongs_to :animal

  field :id,          :type => String,      :store_as => 'SightingID',   :primary_key => true
  field :created_at,  :type => Time,        :store_as => 'CreatedDate'
  field :updated_at,  :type => Time,        :store_as => 'UpdatedDate'
  field :observed_at, :type => Integer,     :store_as => 'SightingDate'
  field :latitude,    :type => Float,       :store_as => 'Latitude'
  field :longitude,   :type => Float,       :store_as => 'Longitude'
  field :geom,        :type => GeomPoint,   :store_as => 'Geom'
  field :address,     :type => String,      :store_as => 'Location'
  field :image_uid,   :type => String,      :store_as => 'ImageURL'
  field :animal_id,   :type => String,      :store_as => 'WildlifeID'
  field :user_id,     :type => String,      :store_as => 'SpotterID'
  field :note,        :type => String,      :store_as => 'Notes',         :default => ''

  def save
    self.geom = GeomPoint.new(self.latitude, self.longitude)
    store_image_thumbnails
    super
  end

  def observed_at=(time)
    super(time.to_i * 1000)
  end

  def observed_at
    epoch_in_ms = super()
    if (epoch_in_ms)
      epoch_in_s = epoch_in_ms / 1000
      Time.at(epoch_in_s)
    else
      nil
    end
  end

  index :observed_at


  private

  def image_uuid
    @uuid ||= SecureRandom.uuid
    self.image_uid ? self.image_uid : @uuid
  end

  def image_format
    format ||= self.image.format
  end

  def store_image_thumbnails
    if self.image
      self.image.thumb('146x195').store( :path => "s/#{image_uuid}.#{image_format}" )
      self.image.thumb('150x150#').store( :path => "#{image_uuid}_q.#{image_format}" )
      self.image.thumb('640x640').store( :path => "#{image_uuid}_z.#{image_format}" )
    end
  end

end



