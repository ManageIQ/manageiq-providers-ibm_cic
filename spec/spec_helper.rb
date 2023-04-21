if ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

Dir[Rails.root.join("spec/shared/**/*.rb")].sort.each { |f| require f }
Dir[File.join(__dir__, "support/**/*.rb")].sort.each { |f| require f }

require "manageiq/providers/ibm_cic"

VCR.configure do |config|
  config.ignore_hosts 'codeclimate.com' if ENV['CI']
  config.cassette_library_dir = ManageIQ::Providers::IbmCic::Engine.root.join("spec/vcr_cassettes")

  secrets = Rails.application.secrets
  secrets.ibm_cic.each_key do |secret|
    config.define_cassette_placeholder(secrets.ibm_cic_defaults[secret]) { secrets.ibm_cic[secret] }
  end
end
