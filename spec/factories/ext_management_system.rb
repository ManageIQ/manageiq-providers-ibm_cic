FactoryBot.define do
  factory :ems_ibm_cic, :class => "ManageIQ::Providers::IbmCic::CloudManager", :parent => :ems_cloud

  factory :ems_ibm_cic_with_vcr_authentication, :parent => :ems_ibm_cic do
    api_version       { "v3" }
    hostname          { VcrSecrets.ibm_cic.hostname }
    port              { VcrSecrets.ibm_cic.port }
    provider_region   { VcrSecrets.ibm_cic.region }
    security_protocol { VcrSecrets.ibm_cic.security_protocol }
    uid_ems           { VcrSecrets.ibm_cic.domain_id }

    after(:create) do |ems|
      username = VcrSecrets.ibm_cic.username
      password = VcrSecrets.ibm_cic.password

      ems.authentications << FactoryBot.create(:authentication, :userid => username, :password => password)
    end
  end
end
