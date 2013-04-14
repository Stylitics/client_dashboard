class RScriptRun
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :output, type: String
  field :err, type: String

  attr_accessible :output, :err, :r_script_id

  belongs_to :r_script

  def generate_script
    code = r_script.code
    code.scan(/\{\{(.*?)\}\}/).each do |v|
      code.gsub!("{{#{v[0].camelize(:lower)}}}", self[v[0].camelize(:lower).underscore.to_sym])
    end
    code.gsub!('{#json_output#}', "#{Rails.root}/tmp/runs/#{r_script.id}.json")
    File.open("#{Rails.root}/tmp/runs/#{r_script.id}.r", 'w') {|f| f.write(code) }
  end

  def run_script
    e = system "Rscript '#{Rails.root}/tmp/runs/#{r_script.id}.r'"

    json_output = ''
    if File.exists?("#{Rails.root}/tmp/runs/#{r_script.id}.json")
      f = File.new("#{Rails.root}/tmp/runs/#{r_script.id}.json", "r")
      while (l = f.gets)
        json_output << l
      end
      f.close
    end

    self.update_attributes  output: JSON.pretty_generate(JSON.parse(json_output)),
                            err: e
  end
end
