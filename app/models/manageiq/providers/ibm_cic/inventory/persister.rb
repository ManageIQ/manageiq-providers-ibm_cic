class ManageIQ::Providers::IbmCic::Inventory::Persister < ManageIQ::Providers::Openstack::Inventory::Persister
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager
  require_nested :TargetCollection
end
