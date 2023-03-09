FactoryBot.define do
  factory :flavor_ibm_cic, :parent => :flavor_openstack, :class => "ManageIQ::Providers::IbmCic::CloudManager::Flavor"
end
