class ManageIQ::Providers::IbmCic::Inventory::Collector < ManageIQ::Providers::Openstack::Inventory::Collector
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager
  require_nested :TargetCollection
end
