class RScriptRun
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :output, type: String
  field :result, type: String

  attr_accessible :output, :err, :r_script_id

  belongs_to :r_script

  def run_script
    require 'open3'

    code = r_script.code
    code.scan(/\{\{(.*?)\}\}/).each do |v|
      code.gsub("{{#{v[0]}}}", v[0])
    end
    File.open("#{Rails.root}/tmp/runs/#{id}.r", 'w') {|f| f.write(code) }

    stdin, stdout, stderr = Open3.popen3("Rscript '#{Rails.root}/tmp/runs/#{id}.r'")
    self.update_attributes  output: stdout.readlines,
                            err: stderr.readlines
  end
end
