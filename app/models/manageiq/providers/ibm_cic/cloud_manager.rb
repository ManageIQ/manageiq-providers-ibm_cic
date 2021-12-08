ManageIQ::Providers::Openstack::CloudManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::IbmCic::CloudManager < ManageIQ::Providers::Openstack::CloudManager
  require_nested :AuthKeyPair
  require_nested :AvailabilityZone
  require_nested :AvailabilityZoneNull
  require_nested :CloudResourceQuota
  require_nested :CloudTenant
  require_nested :EventCatcher
  require_nested :Flavor
  require_nested :HostAggregate
  require_nested :MetricsCapture
  require_nested :MetricsCollectorWorker
  require_nested :Refresher
  require_nested :RefreshWorker
  require_nested :Template
  require_nested :Vm

  def self.vm_vendor
    "ibm_z_vm"
  end

  def self.ems_type
    @ems_type ||= "ibm_cic".freeze
  end

  def self.description
    @description ||= "IBM Cloud Infrastructure Center".freeze
  end

  def image_name
    "ibm_cic"
  end

  def ensure_network_manager
    return false if network_manager

    build_network_manager(:type => 'ManageIQ::Providers::IbmCic::NetworkManager')
    true
  end

  def ensure_cinder_manager
    return false if cinder_manager

    build_cinder_manager(:type => 'ManageIQ::Providers::IbmCic::StorageManager::CinderManager')
    true
  end

  def ensure_swift_manager
    false
  end
end
