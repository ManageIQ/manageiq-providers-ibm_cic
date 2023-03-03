FactoryBot.define do
  factory :template_ibm_cic, :class => "ManageIQ::Providers::IbmCic::CloudManager::Template", :parent => :template_openstack do
    vendor { "ibm_z_vm" }
  end
end
