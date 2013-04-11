require 'spec_helper'

describe RScript do
  it "generates code before each validation from it's sources" do
    r_script = FactoryGirl.build(:r_script)
    r_script.name = 'Test R Script'
    r_script.should_not be_valid

    # now with some sources
    test_codes = []
    (rand(3) + 1).times do |t|
      r_script_source = FactoryGirl.build(:r_script_source, name: "R-source-#{t}.rb", code: "
          some_var <- '#{t}'
        ")
      r_script_source.should be_valid
      r_script.sources << r_script_source
      test_codes << r_script_source.code
    end

    r_script.should be_valid
    test_codes.each do |test_code|
      r_script.code.should include test_code
    end
  end

  it "activate the script by generating running code" do
    r_script = FactoryGirl.build(:r_script)
    r_script.name = 'Test R Script'

    test_codes = []
    (rand(3) + 1).times do |t|
      r_script_source = FactoryGirl.build(:r_script_source, name: "R-source-#{t}.rb", code: "
          some_var <- '#{t}'
        ")
      r_script.sources << r_script_source
      test_codes << r_script_source.code
    end
    r_script.save

    r_script.activate!
    r_script.running_code.should eq(r_script.code)

    r_script.activate!(false)
    r_script.running_code.should be_nil
  end
end
