class RScript
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Versioning
  include Mongoid::Slug

  field :name, type: String
  field :code, type: String
  field :status, type: Boolean

  validates_presence_of :name, :code

  attr_accessible :name, :code, :status

  default_scope order_by(name: :asc)

  has_many :runs, :class_name => 'RScriptRun'
  has_many :charts

  slug :name

  def variables
    code.scan(/\{\{(.*?)\}\}/).collect{|v| v[0].underscore}
  end

  def last_run
    unless runs.any?
      runs << RScriptRun.new(r_script_id: id)
    end
    runs.last
  end

  def activate(mode = true)
    self.update_attribute :status, mode
  end
end
