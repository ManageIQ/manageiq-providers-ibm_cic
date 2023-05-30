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
    expect(ems.cloud_resource_quotas.count).to eq(26)
    expect(ems.cloud_services.count).to eq(5)
    expect(ems.cloud_tenants.count).to eq(1)
    expect(ems.flavors.count).to eq(9)
    expect(ems.host_aggregates.count).to eq(1)
    expect(ems.miq_templates.count).to eq(2)
    expect(ems.vms.count).to eq(11)

    expect(ems.network_manager.cloud_networks.count).to eq(6)
    expect(ems.network_manager.cloud_subnets.count).to eq(3)
    expect(ems.network_manager.network_ports.count).to eq(12)
    expect(ems.network_manager.network_routers.count).to eq(3)
    expect(ems.network_manager.security_groups.count).to eq(3)
    expect(ems.network_manager.firewall_rules.count).to eq(10)
  end

  def assert_specific_availability_zone
    az = ems.availability_zones.find_by(:ems_ref => "Default_Group")
    expect(az).to have_attributes(
      :name                        => "Default_Group",
      :ems_ref                     => "Default_Group",
      :type                        => "ManageIQ::Providers::IbmCic::CloudManager::AvailabilityZone",
      :provider_services_supported => array_including("compute")
    )
  end

  def assert_specific_cloud_resource_quota
    crq = ems.cloud_resource_quotas.find_by(:ems_ref => "[\"9de7cab5c5f34f8382d2465d5197fa88\", \"cores\"]")
    expect(crq).to have_attributes(
      :ems_ref      => "[\"9de7cab5c5f34f8382d2465d5197fa88\", \"cores\"]",
      :service_name => "Compute",
      :name         => "cores",
      :value        => 35_000,
      :type         => "ManageIQ::Providers::IbmCic::CloudManager::CloudResourceQuota",
      :cloud_tenant => ems.cloud_tenants.find_by(:name => "ibm-default")
    )
  end

  def assert_specific_cloud_service
    cloud_service = ems.cloud_services.find_by(:ems_ref => "7")
    expect(cloud_service).to have_attributes(
      :ems_ref             => "7",
      :source              => "compute",
      :executable_name     => "nova-compute",
      :hostname            => "os006",
      :status              => "up",
      :scheduling_disabled => false,
      :availability_zone   => ems.availability_zones.find_by(:ems_ref => "Default_Group")
    )
  end

  def assert_specific_cloud_tenant
    tenant = ems.cloud_tenants.find_by(:ems_ref => "9de7cab5c5f34f8382d2465d5197fa88")
    expect(tenant).to have_attributes(
      :name        => "ibm-default",
      :description => "IBM Default Tenant",
      :enabled     => true,
      :ems_ref     => "9de7cab5c5f34f8382d2465d5197fa88",
      :type        => "ManageIQ::Providers::IbmCic::CloudManager::CloudTenant"
    )
  end

  def assert_specific_flavor
    flavor = ems.flavors.find_by(:ems_ref => "074510d32ec4fd3253ba5e690efac4ce")
    expect(flavor).to have_attributes(
      :name                 => "074510d32ec4fd3253ba5e690efac4ce",
      :description          => "1 CPUs, 4 GB RAM, 10 GB Root Disk",
      :cpu_total_cores      => 1,
      :cpu_cores_per_socket => nil,
      :memory               => 4.gigabytes,
      :ems_ref              => "074510d32ec4fd3253ba5e690efac4ce",
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
      :name     => "Default_Group",
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
          "availability_zone"           => "Default_Group"
        }
      )
    )
  end

  def assert_specific_miq_template
    image = ems.miq_templates.find_by(:name => "rhel83")
    expect(image).to have_attributes(
      :vendor          => "ibm_z_vm",
      :name            => "rhel83",
      :description     => nil,
      :location        => "unknown",
      :uid_ems         => "c7cec3a7-85f8-4d06-8881-07b7bfbfb8a9",
      :power_state     => "never",
      :type            => "ManageIQ::Providers::IbmCic::CloudManager::Template",
      :ems_ref         => "c7cec3a7-85f8-4d06-8881-07b7bfbfb8a9",
      :raw_power_state => "never"
    )
    expect(image.cloud_tenants).to include(ems.cloud_tenants.find_by(:name => "ibm-default"))
  end

  def assert_specific_vm
    vm = ems.vms.find_by(:name => "vm-1")
    expect(vm).to have_attributes(
      :vendor            => "ibm_z_vm",
      :name              => "vm-1",
      :description       => nil,
      :location          => "unknown",
      :uid_ems           => "db956241-dd02-49f3-9858-80a7ef0e740f",
      :power_state       => "on",
      :connection_state  => "connected",
      :type              => "ManageIQ::Providers::IbmCic::CloudManager::Vm",
      :ems_ref           => "db956241-dd02-49f3-9858-80a7ef0e740f",
      :flavor            => ems.flavors.find_by(:name => "074510d32ec4fd3253ba5e690efac4ce"),
      :availability_zone => ems.availability_zones.find_by(:name => "Default_Group"),
      :cloud_tenant      => ems.cloud_tenants.find_by(:name => "ibm-default"),
      :raw_power_state   => "ACTIVE"
    )
  end

  def assert_specific_cloud_network
    network = ems.network_manager.cloud_networks.find_by(:name => "Test_Network_1")
    expect(network).to have_attributes(
      :name                      => "Test_Network_1",
      :ems_ref                   => "3118b2d5-4109-4702-96a7-760ace75a86d",
      :cidr                      => nil,
      :status                    => "active",
      :enabled                   => true,
      :external_facing           => false,
      :cloud_tenant              => ems.cloud_tenants.find_by(:name => "ibm-default"),
      :shared                    => false,
      :provider_physical_network => "icicvlan2",
      :provider_network_type     => "flat",
      :provider_segmentation_id  => nil,
      :vlan_transparent          => nil,
      :extra_attributes          => hash_including(
        :port_security_enabled     => true,
        :qos_policy_id             => nil,
        :maximum_transmission_unit => 0
      ),
      :type                      => "ManageIQ::Providers::IbmCic::NetworkManager::CloudNetwork::Private",
      :description               => nil
    )
  end

  def assert_specific_cloud_subnet
    subnet = ems.network_manager.cloud_subnets.find_by(:ems_ref => "06218699-3dac-43a6-981f-4d1d78606070")
    expect(subnet).to have_attributes(
      :name             => "flat1",
      :ems_ref          => "06218699-3dac-43a6-981f-4d1d78606070",
      :cloud_network    => ems.cloud_networks.find_by(:ems_ref => "b73787b9-0c62-4822-8eaa-8c91753e66df"),
      :cidr             => "172.26.0.0/24",
      :status           => "active",
      :dhcp_enabled     => false,
      :gateway          => "172.26.0.1",
      :network_protocol => "ipv4",
      :cloud_tenant     => ems.cloud_tenants.find_by(:name => "ibm-default"),
      :dns_nameservers  => [],
      :extra_attributes => hash_including(
        :allocation_pools => array_including({"end" => "172.26.0.254", "start" => "172.26.0.2"}),
        :host_routes      => [],
        :ip_version       => 4
      ),
      :type             => "ManageIQ::Providers::IbmCic::NetworkManager::CloudSubnet"
    )
  end

  def assert_specific_network_port
    port = ems.network_manager.network_ports.find_by(:ems_ref => "a17ab4da-7751-494c-8f6c-48b3fb2cb17a")
    expect(port).to have_attributes(
      :type                           => "ManageIQ::Providers::IbmCic::NetworkManager::NetworkPort",
      :name                           => "fa:16:3e:fc:29:19",
      :ems_ref                        => "a17ab4da-7751-494c-8f6c-48b3fb2cb17a",
      :mac_address                    => "fa:16:3e:fc:29:19",
      :status                         => "ACTIVE",
      :admin_state_up                 => true,
      :device_owner                   => "compute:Default_Group",
      :device_ref                     => "db956241-dd02-49f3-9858-80a7ef0e740f",
      :device                         => ems.vms.find_by(:name => "vm-1"),
      :cloud_tenant                   => ems.cloud_tenants.find_by(:name => "ibm-default"),
      :binding_host_id                => "os006",
      :binding_virtual_interface_type => "ovs",
      :extra_attributes               => hash_including(
        :binding_virtual_nic_type          => "normal",
        :extra_dhcp_opts                   => [],
        :allowed_address_pairs             => [],
        :binding_virtual_interface_details => hash_including(
          "connectivity"    => "l2",
          "port_filter"     => true,
          "ovs_hybrid_plug" => false,
          "datapath_type"   => "system",
          "bridge_name"     => "br-int"
        ),
        :binding_profile                   => {}
      )
    )
  end

  def assert_specific_security_group
    security_group = ems.network_manager.security_groups.find_by(:ems_ref => "799e6994-e7cd-4b4c-b485-a52926fae489")
    expect(security_group).to have_attributes(
      :name         => "default",
      :description  => "Default security group",
      :type         => "ManageIQ::Providers::IbmCic::NetworkManager::SecurityGroup",
      :ems_ref      => "799e6994-e7cd-4b4c-b485-a52926fae489",
      :cloud_tenant => ems.cloud_tenants.find_by(:name => "ibm-default")
    )
  end
end
