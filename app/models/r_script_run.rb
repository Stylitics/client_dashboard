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
      code.gsub!("{{#{v[0].camelize(:lower)}}}", self[v[0].camelize(:lower).underscore.to_sym])
    end
    code.gsub!('{#json_output#}', "#{Rails.root}/tmp/runs/#{id}.json")
    File.open("#{Rails.root}/tmp/runs/#{id}.r", 'w') {|f| f.write(code) }

    stdin, stdout, stderr = Open3.popen3("Rscript '#{Rails.root}/tmp/runs/#{id}.r'")

    json_output = ''
    if File.exists?("#{Rails.root}/tmp/runs/#{id}.json")
      f = File.new("#{Rails.root}/tmp/runs/#{id}.json", "r")
      while (l = f.gets)
        json_output << l
      end
      f.close
      json_output = JSON.pretty_generate(JSON.parse(json_output))
    end

    self.update_attributes  output: json_output,
                            err: stderr.readlines.join('')
  end
end
