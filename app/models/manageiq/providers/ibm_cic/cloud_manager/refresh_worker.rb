class ManageIQ::Providers::IbmCic::CloudManager::RefreshWorker < ManageIQ::Providers::BaseManager::RefreshWorker
  def self.settings_name
    :ems_refresh_worker_ibm_cic
  end
end
