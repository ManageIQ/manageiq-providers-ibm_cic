FactoryBot.define do
  factory :cloud_tenant_ibm_cic, :parent => :cloud_subnet_openstack, :class => "ManageIQ::Providers::IbmCic::CloudManager::CloudTenant"
end
