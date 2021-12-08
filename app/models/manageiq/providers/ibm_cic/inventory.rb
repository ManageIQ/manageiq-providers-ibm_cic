class ManageIQ::Providers::IbmCic::Inventory < ManageIQ::Providers::Openstack::Inventory
  require_nested :Collector
  require_nested :Parser
  require_nested :Persister
end
