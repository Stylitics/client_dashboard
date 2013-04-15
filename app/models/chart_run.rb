class ChartRun
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :output, type: String
  field :query, type: String

  attr_accessible :output, :chart_id

  belongs_to :chart
end
