require 'simplecov'
SimpleCov.start

require 'rspec/expectations'
$LOAD_PATH << "lib"
$LOAD_PATH << "models"

require 'environment'
require 'log'
require 'person'
require 'location'

Environment.environment = "test"

def run_H_iR_with_input(*inputs)
  shell_output = ""
   IO.popen('ENVIRONMENT=test ruby How_iRoll.rb', 'r+') do |pipe|
    inputs.each do |input|
      pipe.puts input
    end
    pipe.close_write
    shell_output << pipe.read
  end
  shell_output
end

RSpec.configure do |config|
  config.after(:each) do
    Environment.database_connection.execute("DELETE FROM logs;")
    Environment.database_connection.execute("DELETE FROM people;")
    Environment.database_connection.execute("DELETE FROM locations;")
  end
end

RSpec::Matchers.define :include_in_order do |*expected|
  match do |actual|
    input = actual.delete("\n")
    regexp_string = expected.join(".*").gsub("?","\\?").gsub("\n",".*")
    result = /#{regexp_string}/.match(input)
    result.should be
  end
end
