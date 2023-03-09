FactoryBot.define do
  factory :cloud_network_ibm_cic,         :parent => :cloud_network_openstack, :class => "ManageIQ::Providers::IbmCic::NetworkManager::CloudNetwork"
  factory :cloud_network_public_ibm_cic,  :parent => :cloud_network_public_openstack, :class => "ManageIQ::Providers::IbmCic::NetworkManager::CloudNetwork::Public"
  factory :cloud_network_private_ibm_cic, :parent => :cloud_network_private_openstack, :class => "ManageIQ::Providers::IbmCic::NetworkManager::CloudNetwork::Private"
end
