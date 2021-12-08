ManageIQ::Providers::Openstack::StorageManager::CinderManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::IbmCic::StorageManager::CinderManager < ManageIQ::Providers::Openstack::StorageManager::CinderManager
  require_nested :CloudVolume
  require_nested :CloudVolumeBackup
  require_nested :CloudVolumeSnapshot
  require_nested :CloudVolumeType
  require_nested :EventCatcher

  def self.ems_type
    @ems_type ||= "ibm_cic_cinder".freeze
  end

  def self.description
    @description ||= "IBM Cloud Infrastructure Center Cinder".freeze
  end
end
