ManageIQ::Providers::Openstack::StorageManager::CinderManager::EventCatcher.include(ActsAsStiLeafClass)

class ManageIQ::Providers::IbmCic::StorageManager::CinderManager::EventCatcher < ManageIQ::Providers::Openstack::StorageManager::CinderManager::EventCatcher
  require_nested :Runner

  def self.settings_name
    :event_catcher_ibm_cic_cinder
  end
end
