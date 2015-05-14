class Animal
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  store_in :database => ENV['RETHINKDB_DB'], :table => 'Wildlife'

  has_many :observations

  field :id,          :type => String,      :store_as => 'WildlifeID',   :primary_key => true
  field :created_at,  :type => Time,        :store_as => 'CreatedDate'
  field :updated_at,  :type => Time,        :store_as => 'UpdatedDate'
  field :name,        :type => String,      :store_as => 'Name'
  field :gender,      :type => String,      :store_as => 'Gender'
  field :tag_code,    :type => Integer,     :store_as => 'Tag'
  field :tag_colour,  :type => String,      :store_as => 'Colour',        :default => TagColours::YELLOW
  field :notes,       :type => String,      :store_as => 'Notes'

  def save!
    self.save
  end
end