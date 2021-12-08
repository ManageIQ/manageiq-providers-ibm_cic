ManageIQ::Providers::Openstack::StorageManager::SwiftManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::IbmCic::StorageManager::SwiftManager < ManageIQ::Providers::Openstack::StorageManager::SwiftManager
  def self.ems_type
    @ems_type ||= "ibm_cic_swift".freeze
  end

  def self.description
    @description ||= "IBM Cloud Infrastructure Center Swift".freeze
  end
end
