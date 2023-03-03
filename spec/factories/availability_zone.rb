FactoryBot.define do
  factory :availability_zone_ibm_cic,      :parent => :availability_zone_openstack, :class => "ManageIQ::Providers::IbmCic::CloudManager::AvailabilityZone"
  factory :availability_zone_ibm_cic_null, :parent => :availability_zone_openstack_null, :class => "ManageIQ::Providers::IbmCic::CloudManager::AvailabilityZoneNull"
end
