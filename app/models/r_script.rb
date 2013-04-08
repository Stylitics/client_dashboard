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

  attr_accessible :name, :code, :running_code, :status, :sources_attributes

  default_scope order_by(name: :asc)

  has_many :runs, :class_name => 'RScriptRun'

  embeds_many :sources, class_name: 'RScriptSource'
  accepts_nested_attributes_for :sources, allow_destroy: true

  slug :name

  before_validation :update_code_from_sources

  def variables
    code.scan(/\{\{(.*?)\}\}/).collect{|v| v[0]}
  end

private

  def update_code_from_sources
    self.code = ''
    sources.each do |s|
      self.code << s.code + "\n"
    end
  end
end
