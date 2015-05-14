class User
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  store_in :database => ENV['RETHINKDB_DB'], :table => 'Spotter'

  has_many :observations

  field :id,          :type => String,      :store_as => 'SpotterID',   :primary_key => true
  field :created_at,  :type => Time,        :store_as => 'CreatedDate'
  field :updated_at,  :type => Time,        :store_as => 'UpdatedDate'
  field :first_name,  :type => String,      :store_as => 'FirstName',   :default => 'Unknown'
  field :last_name,   :type => String,      :store_as => 'LastName',    :default => 'Unknown'
  field :role,        :type => String,      :store_as => 'Role',        :default => 'Visitor'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
#  devise :database_authenticatable, :registerable,
#         :recoverable, :rememberable, :trackable, :validatable
#
  ## Database authenticatable
  field :email,               :store_as => 'Email',             :type => String, :default => ""
  field :encrypted_password,  :store_as => 'EncryptedPassword', :type => String, :default => ""
#
#  ## Recoverable
#  field :reset_password_token,   :type => String
#  field :reset_password_sent_at, :type => Time
#
#  ## Rememberable
#  field :remember_created_at, :type => Time
#
#  ## Trackable
#  field :sign_in_count,      :type => Integer, :default => 0
#  field :current_sign_in_at, :type => Time
#  field :last_sign_in_at,    :type => Time
#  field :current_sign_in_ip, :type => String
#  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time
  
  index :email

  def save!
    self.save
  end


  # The following fields are implemented in the db, but
  # don't really belong in the User model. Implement if
  # needed.
  #
  # field :device_uid, as: 'DeviceUID', :type => String

end
