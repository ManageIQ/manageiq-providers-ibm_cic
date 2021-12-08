class ManageIQ::Providers::IbmCic::Inventory::Parser < ManageIQ::Providers::Openstack::Inventory::Parser
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager
end
