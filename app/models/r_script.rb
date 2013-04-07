class RScript
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Versioning

  field :name, type: String
  field :template, type: String
  field :code, type: String
  field :status, type: Integer

  validates_presence_of :name, :template

  attr_accessible :name, :template, :code, :status

  default_scope order_by(name: :asc)
end
