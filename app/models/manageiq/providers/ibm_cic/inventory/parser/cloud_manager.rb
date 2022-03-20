class ManageIQ::Providers::IbmCic::Inventory::Parser::CloudManager < ManageIQ::Providers::Openstack::Inventory::Parser::CloudManager
 
  def parse_vm(vm, hosts)
    super
    server = persister.vms.find_or_build(vm.id.to_s)
    hardware = persister.hardwares.find_or_build(server)
    # In openstack provider hardware cpu_speed is retrieved from the parent_host.
    # hardware.cpu_speed = parent_host.try(:hardware).try(:cpu_speed)
    # In cic provider, cpu_speed is from server details and set to hardware cpu_speed
    if vm.attributes.key?("cpu_speed")
      hardware.cpu_speed = vm.attributes["cpu_speed"]
    end
  end
end
