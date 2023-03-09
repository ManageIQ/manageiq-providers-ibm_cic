FactoryBot.define do
  factory :network_router_ibm_cic, :parent => :network_router_openstack, :class => "ManageIQ::Providers::IbmCic::NetworkManager::NetworkRouter"
end
