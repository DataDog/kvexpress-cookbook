# Encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  # # Specify the path for Chef Solo to find roles (default: [ascending search])
  # config.role_path = '/var/roles'

  # prevent any WARN messages during testing
  config.log_level = :error

  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'ubuntu'

  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '14.04'
end

ChefSpec::Coverage.start!
