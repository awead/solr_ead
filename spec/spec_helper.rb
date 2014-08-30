# :nodoc
require "solr_ead"
require "byebug" unless ENV['TRAVIS']

RSpec.configure do |config|

  # == Mock Framework
  # Note: we're not mocking... yet.
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #config.mock_with :rspec

  config.color = true

end

def fixture(file) #:nodoc
  File.new(File.join(File.dirname(__FILE__), 'fixtures', file))
end

def debug_solr_doc(doc) #:nodoc
  doc.keys.each do |key|
    unless key.to_s.match("xml_t")
      puts "#" * 50
      puts key.to_s + "==="
      puts doc[key]
    end
  end
end