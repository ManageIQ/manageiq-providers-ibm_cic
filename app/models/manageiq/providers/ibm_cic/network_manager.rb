ManageIQ::Providers::Openstack::NetworkManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::IbmCic::NetworkManager < ManageIQ::Providers::Openstack::NetworkManager
  require_nested :CloudNetwork
  require_nested :CloudSubnet
  require_nested :EventCatcher
  require_nested :FloatingIp
  require_nested :NetworkPort
  require_nested :NetworkRouter
  require_nested :SecurityGroup

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
