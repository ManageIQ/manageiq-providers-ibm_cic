FactoryBot.define do
  factory :cloud_subnet_ibm_cic, :parent => :cloud_subnet_openstack, :class => "ManageIQ::Providers::IbmCic::NetworkManager::CloudSubnet"
end
