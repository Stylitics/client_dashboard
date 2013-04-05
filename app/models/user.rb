class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  field :first_name, type: String, default: ''
  field :last_name, type: String, default: ''

  has_many :r_scripts

  validates_presence_of :email, :first_name, :last_name
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email

  index({ email: 1 }, { unique: true, background: true })
  attr_accessible :email, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at, :first_name, :last_name

  def name
    "#{first_name} #{last_name.first}"
  end
end
