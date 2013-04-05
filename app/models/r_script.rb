class RScript
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Versioning

  field :code, type: String

  belongs_to :user

  validates_presence_of :user_id, :content

  attr_accessible :code, :user_id
end
