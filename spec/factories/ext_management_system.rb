FactoryBot.define do
  factory :ems_ibm_cic, :class => "ManageIQ::Providers::IbmCic::CloudManager", :parent => :ems_cloud

  factory :ems_ibm_cic_with_vcr_authentication, :parent => :ems_ibm_cic do
    api_version       { "v3" }
    hostname          { Rails.application.secrets.ibm_cic[:hostname] }
    port              { Rails.application.secrets.ibm_cic[:port] }
    provider_region   { Rails.application.secrets.ibm_cic[:region] }
    security_protocol { Rails.application.secrets.ibm_cic[:security_protocol] }
    uid_ems           { Rails.application.secrets.ibm_cic[:domain_id] }

    after(:create) do |ems|
      username = Rails.application.secrets.ibm_cic[:username]
      password = Rails.application.secrets.ibm_cic[:password]

      ems.authentications << FactoryBot.create(:authentication, :userid => username, :password => password)
    end
  end
end
