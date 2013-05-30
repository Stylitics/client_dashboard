class RScriptRun
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :output, type: String
  field :err, type: String
  field :generated_script, type: String

  attr_accessible :output, :err, :generated_script, :r_script_id

  belongs_to :r_script

  def generate_script
    code = r_script.code

    # this is dupplicate. will refactor later on

    # SQL connection
    code.gsub!("{!hostVar!}", SQL_HOST)
    code.gsub!("{!portVar!}", SQL_PORT.to_s)
    code.gsub!("{!dbnameVar!}", SQL_DB)
    code.gsub!("{!userVar!}", SQL_USER)
    code.gsub!("{!passVar!}", SQL_PASS)
    # end SQL connection

    code.scan(/\{\{(.*?)\}\}/).each do |v|
      injected_value = self[v[0].camelize(:lower).underscore.to_sym].to_a.join(",")
      injected_value = "NULL" if injected_value.blank? and v[0].camelize(:lower).include?("_sub_")
      code.gsub!("{{#{v[0].camelize(:lower)}}}", injected_value)
    end
    # remove "NULL"s
    code.gsub!("NULL", NULL)
    code.gsub!('{#json_output#}', "#{Rails.root}/tmp/runs/#{r_script.id}.json")
    File.open("#{Rails.root}/tmp/runs/#{r_script.id}.r", 'w') {|f| f.write(code) }
  end

  def run_script
    g = ""
    f = File.new("#{Rails.root}/tmp/runs/#{r_script.id}.r", "r")
    while (l = f.gets)
      g << l
    end
    f.close

    e = system "Rscript '#{Rails.root}/tmp/runs/#{r_script.id}.r'"

    json_output = ''
    if File.exists?("#{Rails.root}/tmp/runs/#{r_script.id}.json")
      f = File.new("#{Rails.root}/tmp/runs/#{r_script.id}.json", "r")
      while (l = f.gets)
        json_output << l
      end
      f.close
    end

    o = JSON.pretty_generate(JSON.parse(json_output)) rescue "{}"

    self.update_attributes  output: o,
                            err: e,
                            generated_script: g
  end
end
