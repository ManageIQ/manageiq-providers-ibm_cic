if ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

Dir[Rails.root.join("spec/shared/**/*.rb")].sort.each { |f| require f }
Dir[File.join(__dir__, "support/**/*.rb")].sort.each { |f| require f }
Dir[ManageIQ::Providers::Openstack::Engine.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

require "manageiq/providers/ibm_cic"

VCR.configure do |config|
  config.ignore_hosts 'codeclimate.com' if ENV['CI']
  config.cassette_library_dir = ManageIQ::Providers::IbmCic::Engine.root.join("spec/vcr_cassettes")

  fix_token_expires_at(config)

  VcrSecrets.define_all_cassette_placeholders(config, :ibm_cic)
end
