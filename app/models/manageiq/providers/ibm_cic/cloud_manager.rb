ManageIQ::Providers::Openstack::CloudManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::IbmCic::CloudManager < ManageIQ::Providers::Openstack::CloudManager
  supports :catalog
  supports :create

  def self.vm_vendor
    "ibm_z_vm"
  end

  def self.ems_type
    @ems_type ||= "ibm_cic".freeze
  end

  def self.description
    @description ||= "IBM Cloud Infrastructure Center".freeze
  end

  def self.catalog_types
    {"IbmCic" => N_("IBM Cloud Infrastructure Center")}
  end

  has_one :network_manager,
          :foreign_key => :parent_ems_id,
          :class_name  => "ManageIQ::Providers::IbmCic::NetworkManager",
          :autosave    => true,
          :dependent   => :destroy
  has_one :cinder_manager,
          :foreign_key => :parent_ems_id,
          :class_name  => "ManageIQ::Providers::IbmCic::StorageManager::CinderManager",
          :dependent   => :destroy,
          :inverse_of  => :parent_manager,
          :autosave    => true

  def image_name
    "ibm_cic"
  end

  def ensure_swift_manager
    false
  end

  def self.params_for_create
      {
        :fields => super[:fields].delete_if { |x| x[:id] == "provider_id" }
      }
  end
end
