class RScript
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Versioning
  include Mongoid::Slug

  field :name, type: String
  field :code, type: String
  field :running_code, type: String
  field :status, type: Integer

  validates_presence_of :name, :code

  attr_accessible :name, :code, :running_code, :status

  default_scope order_by(name: :asc)

  embeds_many :sources, class_name: 'RScriptSource'

  slug :name
end
