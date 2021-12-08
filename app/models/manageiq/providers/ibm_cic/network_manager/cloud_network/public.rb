class ManageIQ::Providers::IbmCic::NetworkManager::CloudNetwork::Public < ManageIQ::Providers::IbmCic::NetworkManager::CloudNetwork
  def self.display_name(number = 1)
    n_('Cloud Network (IBM CIC)', 'Cloud Networks (IBM CIC)', number)
  end
end
