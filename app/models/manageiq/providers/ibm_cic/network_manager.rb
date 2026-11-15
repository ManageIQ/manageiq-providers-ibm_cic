ManageIQ::Providers::Openstack::NetworkManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::IbmCic::NetworkManager < ManageIQ::Providers::Openstack::NetworkManager
  class << self
    delegate :refresh_ems, :to => ManageIQ::Providers::IbmCic::CloudManager
  end

  def self.ems_type
    @ems_type ||= "ibm_cic_network".freeze
  end

  def self.description
    @description ||= "IBM Cloud Infrastructure Center Network".freeze
  end

  def image_name
    "ibm_cic"
  end
end
