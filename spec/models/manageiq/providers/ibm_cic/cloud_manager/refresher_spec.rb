describe ManageIQ::Providers::IbmCic::CloudManager::Refresher do
  it ".ems_type" do
    expect(described_class.ems_type).to eq(:ibm_cic)
  end

  let(:zone) { EvmSpecHelper.create_guid_miq_server_zone.last }
  let!(:ems) { FactoryBot.create(:ems_ibm_cic_with_vcr_authentication, :zone => zone) }

  it "will perform a full refresh" do
    1.times do # TODO: running this twice causes weird VCR failures with the VNF service
      VCR.use_cassette(described_class.name.underscore) do
        EmsRefresh.refresh(ems)
        EmsRefresh.refresh(ems.network_manager) if ems.network_manager
      end

      ems.reload

      assert_table_counts
      assert_specific_availability_zone
      assert_specific_cloud_resource_quota
      assert_specific_cloud_service
      assert_specific_cloud_tenant
      assert_specific_flavor
      assert_specific_host_aggregate
      assert_specific_miq_template
      assert_specific_vm
      assert_specific_cloud_network
      assert_specific_cloud_subnet
      assert_specific_network_port
      assert_specific_security_group
    end
  end

  def assert_table_counts
    expect(ems.availability_zones.count).to eq(2)
    expect(ems.cloud_resource_quotas.count).to eq(46)
    expect(ems.cloud_services.count).to eq(5)
    expect(ems.cloud_tenants.count).to eq(2)
    expect(ems.flavors.count).to eq(9)
    expect(ems.host_aggregates.count).to eq(1)
    expect(ems.miq_templates.count).to eq(1)
    expect(ems.vms.count).to eq(6)

    expect(ems.network_manager.cloud_networks.count).to eq(1)
    expect(ems.network_manager.cloud_subnets.count).to eq(1)
    expect(ems.network_manager.network_ports.count).to eq(6)
    expect(ems.network_manager.network_routers.count).to eq(0)
    expect(ems.network_manager.security_groups.count).to eq(3)
    expect(ems.network_manager.firewall_rules.count).to eq(12)
  end

  def assert_specific_availability_zone
    az = ems.availability_zones.find_by(:ems_ref => "Default Group")
    expect(az).to have_attributes(
      :name                        => "Default Group",
      :ems_ref                     => "Default Group",
      :type                        => "ManageIQ::Providers::IbmCic::CloudManager::AvailabilityZone",
      :provider_services_supported => array_including("compute")
    )
  end

  def assert_specific_cloud_resource_quota
    crq = ems.cloud_resource_quotas.find_by(:ems_ref => "[\"1ae3ec2ccd8f41b8851aca05f264f19a\", \"cores\"]")
    expect(crq).to have_attributes(
      :ems_ref      => "[\"1ae3ec2ccd8f41b8851aca05f264f19a\", \"cores\"]",
      :service_name => "Compute",
      :name         => "cores",
      :value        => 55_000,
      :type         => "ManageIQ::Providers::IbmCic::CloudManager::CloudResourceQuota",
      :cloud_tenant => ems.cloud_tenants.find_by(:ems_ref => "1ae3ec2ccd8f41b8851aca05f264f19a")
    )
  end

  def assert_specific_cloud_service
    cloud_service = ems.cloud_services.find_by(:ems_ref => "6")
    expect(cloud_service).to have_attributes(
      :ems_ref             => "6",
      :source              => "compute",
      :executable_name     => "nova-compute",
      :hostname            => "BOEIAAS3",
      :status              => "up",
      :scheduling_disabled => false,
      :availability_zone   => ems.availability_zones.find_by(:ems_ref => "Default Group")
    )
  end

  def assert_specific_cloud_tenant
    tenant = ems.cloud_tenants.find_by(:ems_ref => "a0311bc440e64cbe90c1b947e171335a")
    expect(tenant).to have_attributes(
      :name        => "ibm-default",
      :description => "IBM Default Tenant",
      :enabled     => true,
      :ems_ref     => "a0311bc440e64cbe90c1b947e171335a",
      :type        => "ManageIQ::Providers::Openstack::CloudManager::CloudTenant" # TODO: Fix openstack parser
    )
  end

  def assert_specific_flavor
    flavor = ems.flavors.find_by(:ems_ref => "2f86d489086a7cff82052bc7f3f04567")
    expect(flavor).to have_attributes(
      :name                 => "2f86d489086a7cff82052bc7f3f04567",
      :description          => "1 CPUs, 4 GB RAM, 10 GB Root Disk",
      :cpu_total_cores      => 1,
      :cpu_cores_per_socket => nil,
      :memory               => 4.gigabytes,
      :ems_ref              => "2f86d489086a7cff82052bc7f3f04567",
      :type                 => "ManageIQ::Providers::IbmCic::CloudManager::Flavor",
      :supports_32_bit      => nil,
      :supports_64_bit      => nil,
      :enabled              => true,
      :supports_hvm         => nil,
      :supports_paravirtual => nil,
      :ephemeral_disk_size  => 0,
      :root_disk_size       => 10.gigabyte,
      :swap_disk_size       => 0,
      :publicly_available   => false,
      :cpu_sockets          => 1
    )
  end

  def assert_specific_host_aggregate
    ha = ems.host_aggregates.find_by(:ems_ref => "1")
    expect(ha).to have_attributes(
      :name     => "Default Group",
      :ems_ref  => "1",
      :type     => "ManageIQ::Providers::IbmCic::CloudManager::HostAggregate",
      :metadata => hash_including(
        {
          "initialpolicy-id"            => "1",
          "hapolicy-id"                 => "1",
          "hapolicy-run_interval"       => "1",
          "hapolicy-stabilization"      => "5",
          "dro_enabled"                 => "False",
          "arr_enabled"                 => "False",
          "runtimepolicy-id"            => "5",
          "runtimepolicy-run_interval"  => "5",
          "runtimepolicy-stabilization" => "2",
          "runtimepolicy-threshold"     => "70",
          "runtimepolicy-max_parallel"  => "10",
          "runtimepolicy-action"        => "migrate_vm_advise_only",
          "availability_zone"           => "Default Group"
        }
      )
    )
  end

  def assert_specific_miq_template
    image = ems.miq_templates.find_by(:ems_ref => "d3f1f3db-9c81-46cc-b5ea-dda649e2ab9d")
    expect(image).to have_attributes(
      :vendor          => "ibm_z_vm",
      :name            => "rhel77",
      :description     => nil,
      :location        => "unknown",
      :uid_ems         => "d3f1f3db-9c81-46cc-b5ea-dda649e2ab9d",
      :power_state     => "never",
      :type            => "ManageIQ::Providers::IbmCic::CloudManager::Template",
      :ems_ref         => "d3f1f3db-9c81-46cc-b5ea-dda649e2ab9d",
      :cloud_tenant    => ems.cloud_tenants.find_by(:ems_ref => "a0311bc440e64cbe90c1b947e171335a"),
      :raw_power_state => "never"
    )
  end

  def assert_specific_vm
    vm = ems.vms.find_by(:ems_ref => "5856ae52-fb89-47ab-9b7a-62c5adbacd98")
    expect(vm).to have_attributes(
      :vendor            => "ibm_z_vm",
      :name              => "rhel77-662",
      :description       => nil,
      :location          => "unknown",
      :uid_ems           => "5856ae52-fb89-47ab-9b7a-62c5adbacd98",
      :power_state       => "on",
      :connection_state  => "connected",
      :type              => "ManageIQ::Providers::IbmCic::CloudManager::Vm",
      :ems_ref           => "5856ae52-fb89-47ab-9b7a-62c5adbacd98",
      :flavor            => ems.flavors.find_by(:ems_ref => "8071ddc45015d3d11b8c880f008cfc0e"),
      :availability_zone => ems.availability_zones.find_by(:ems_ref => "Default Group"),
      :cloud_tenant      => ems.cloud_tenants.find_by(:ems_ref => "a0311bc440e64cbe90c1b947e171335a"),
      :raw_power_state   => "ACTIVE"
    )
  end

  def assert_specific_cloud_network
    network = ems.network_manager.cloud_networks.find_by(:ems_ref => "c83cb025-7717-496d-b5dd-4bfa655ee719")
    expect(network).to have_attributes(
      :name                      => "vlan16",
      :ems_ref                   => "c83cb025-7717-496d-b5dd-4bfa655ee719",
      :cidr                      => nil,
      :status                    => "active",
      :enabled                   => true,
      :external_facing           => false,
      :cloud_tenant              => ems.cloud_tenants.find_by(:ems_ref => "a0311bc440e64cbe90c1b947e171335a"),
      :shared                    => true,
      :provider_physical_network => "icicvlan1",
      :provider_network_type     => "vlan",
      :provider_segmentation_id  => "16",
      :vlan_transparent          => nil,
      :extra_attributes          => hash_including(
        {
          :port_security_enabled     => true,
          :maximum_transmission_unit => 1_500
        }
      ),
      :type                      => "ManageIQ::Providers::IbmCic::NetworkManager::CloudNetwork::Private",
      :description               => nil
    )
  end

  def assert_specific_cloud_subnet
    subnet = ems.network_manager.cloud_subnets.first
    expect(subnet).to have_attributes(
      :name             => "vlan16a",
      :ems_ref          => "ea84b706-143d-4ebf-ad2d-4edd35ff6d11",
      :cloud_network    => ems.cloud_networks.find_by(:ems_ref => "c83cb025-7717-496d-b5dd-4bfa655ee719"),
      :cidr             => "10.16.2.0/24",
      :status           => "active",
      :dhcp_enabled     => false,
      :gateway          => "10.16.2.1",
      :network_protocol => "ipv4",
      :cloud_tenant     => ems.cloud_tenants.find_by(:ems_ref => "a0311bc440e64cbe90c1b947e171335a"),
      :dns_nameservers  => [],
      :extra_attributes => hash_including(
        {
          :allocation_pools => array_including({"start" => "10.16.2.2", "end" => "10.16.2.254"}),
          :host_routes      => [],
          :ip_version       => 4
        }
      ),
      :type             => "ManageIQ::Providers::IbmCic::NetworkManager::CloudSubnet"
    )
  end

  def assert_specific_network_port
    port = ems.network_manager.network_ports.find_by(:ems_ref => "22c1a29e-454b-4f6d-a2d8-27c0b0e8a4be")
    expect(port).to have_attributes(
      :type                           => "ManageIQ::Providers::IbmCic::NetworkManager::NetworkPort",
      :name                           => "fa:16:3e:59:d7:77",
      :ems_ref                        => "22c1a29e-454b-4f6d-a2d8-27c0b0e8a4be",
      :mac_address                    => "fa:16:3e:59:d7:77",
      :status                         => "ACTIVE",
      :admin_state_up                 => true,
      :device_owner                   => "compute:Default Group",
      :device_ref                     => "5856ae52-fb89-47ab-9b7a-62c5adbacd98",
      :device                         => ems.vms.find_by(:ems_ref => "5856ae52-fb89-47ab-9b7a-62c5adbacd98"),
      :cloud_tenant                   => ems.cloud_tenants.find_by(:ems_ref => "a0311bc440e64cbe90c1b947e171335a"),
      :binding_host_id                => "BOEIAAS3",
      :binding_virtual_interface_type => "zvm",
      :extra_attributes               => hash_including(
        {
          :binding_virtual_nic_type          => "normal",
          :binding_virtual_interface_details => hash_including(
            "connectivity" => "legacy",
            "port_filter"  => false
          )
        }
      )
    )
  end

  def assert_specific_security_group
    security_group = ems.network_manager.security_groups.find_by(:ems_ref => "0269a5ce-e5f1-4d55-8ba2-8263a73acc8b")
    expect(security_group).to have_attributes(
      :name         => "default",
      :description  => "Default security group",
      :type         => "ManageIQ::Providers::IbmCic::NetworkManager::SecurityGroup",
      :ems_ref      => "0269a5ce-e5f1-4d55-8ba2-8263a73acc8b",
      :cloud_tenant => ems.cloud_tenants.find_by(:ems_ref => "1ae3ec2ccd8f41b8851aca05f264f19a")
    )
  end
end
