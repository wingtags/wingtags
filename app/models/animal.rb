class Animal
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  store_in :database => ENV['RETHINKDB_DB'], :table => 'Wildlife'

  has_many :observations

  field :id,          :type => String,      :store_as => 'WildlifeID',   :primary_key => true
  field :created_at,  :type => Integer,     :store_as => 'CreatedDate'
  field :updated_at,  :type => Time,        :store_as => 'UpdatedDate'
  field :name,        :type => String,      :store_as => 'Name'
  field :gender,      :type => String,      :store_as => 'Gender',        :default => ''
  field :tag_code,    :type => Integer,     :store_as => 'Tag'
  field :tag_colour,  :type => String,      :store_as => 'Colour',        :default => TagColours::YELLOW
  field :notes,       :type => String,      :store_as => 'Notes'

  def save!
    self.save
  end

  def created_at=(time)
    super(time_to_epoch_in_ms(time))
  end

  def created_at
    epoch_in_ms = super()
    if (epoch_in_ms)
      epoch_in_ms_to_time(epoch_in_ms)
    end
  end
end


private

def time_to_epoch_in_ms(time)
  time.to_i * 1000
end

def epoch_in_ms_to_time(epoch_in_ms)
  epoch_in_s = epoch_in_ms / 1000
  Time.at(epoch_in_s)
end