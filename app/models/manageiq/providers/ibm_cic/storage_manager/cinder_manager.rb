ManageIQ::Providers::Openstack::StorageManager::CinderManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::IbmCic::StorageManager::CinderManager < ManageIQ::Providers::Openstack::StorageManager::CinderManager
  class << self
    delegate :refresh_ems, :to => ManageIQ::Providers::IbmCic::CloudManager
  end

  def self.ems_type
    @ems_type ||= "ibm_cic_cinder".freeze
  end

  def self.description
    @description ||= "IBM Cloud Infrastructure Center Cinder".freeze
  end
end
