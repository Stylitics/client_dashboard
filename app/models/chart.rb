class Chart
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Versioning
  include Mongoid::Slug

  field :name, type: String
  field :result, type: String

  validates_presence_of :name

  attr_accessible :name, :result

  belongs_to :r_script
  has_many :runs, :class_name => 'ChartRun'

  slug :name
end
