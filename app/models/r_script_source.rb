class RScriptSource
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name, type: String
  field :code, type: String

  validates_presence_of :name, :code

  attr_accessible :name, :code

  embedded_in :r_script
end
