class ManageIQ::Providers::IbmCic::CloudManager::ProvisionWorkflow < ManageIQ::Providers::Openstack::CloudManager::ProvisionWorkflow
  def self.provider_model
    ManageIQ::Providers::IbmCic::CloudManager
  end

  def dialog_name_from_automate(message = 'get_dialog_name')
    super(message, {'platform' => 'ibm_cic'})
  end
end
