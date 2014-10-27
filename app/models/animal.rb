class Animal
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  store_in :database => ENV['RETHINKDB_DB'], :table => 'Wildlife'

  field :id,          :type => String,      :as => 'WildlifeID',   :primary_key => true
  field :created_at,  :type => Time,        :as => 'CreatedDate'
  field :updated_at,  :type => Time,        :as => 'UpdatedDate'
  field :name,        :type => String,      :as => 'Name'
  field :gender,      :type => String,      :as => 'Gender'
  field :tag_code,    :type => String,      :as => 'Tag'
  field :tag_colour,  :type => String,      :as => 'Colour'
  field :notes,       :type => String,      :as => 'Notes'

  def save!
    self.save
  end
end