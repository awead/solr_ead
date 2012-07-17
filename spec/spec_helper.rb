#require 'om'
#require 'rspec'

RSpec.configure do |config|

  # == Mock Framework
  # Note: we're not mocking... yet.
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #config.mock_with :rspec

  config.color = true

end

def fixture(file)
  File.new(File.join(File.dirname(__FILE__), 'fixtures', file))
end