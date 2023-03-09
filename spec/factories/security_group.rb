FactoryBot.define do
  factory :security_group_ibm_cic, :parent => :security_group_openstack,
                                   :class  => "ManageIQ::Providers::IbmCic::NetworkManager::SecurityGroup"
end
