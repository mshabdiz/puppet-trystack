class trystack::network () {
    $neutron_sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_ip}/ovs_neutron}"
    
    class { 'neutron':
      rpc_backend => 'neutron.openstack.common.rpc.impl_qpid',
      qpid_hostname => "$qpid_ip",
      core_plugin => 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2',
      verbose => true,
    }
    
    class { 'neutron::server':
      auth_password => $neutron_user_password,
      auth_host => "$private_ip",
      enabled => true,
    }
    
    firewall { '001 neutron incoming':
        proto    => 'tcp',
        dport    => ['9696'],
        action   => 'accept',
    }
    
    class { 'neutron::plugins::ovs':
      tenant_network_type => 'gre',
      tunnel_id_ranges => '1:1000',
      sql_connection      => $neutron_sql_connection
    }
    
    class { 'neutron::agents::l3':
      interface_driver        => 'neutron.agent.linux.interface.OVSInterfaceDriver',
      external_network_bridge => 'br-ex',
    }
    
    sysctl::value { 'net.ipv4.ip_forward':
      value => '1'
    }
    
    
    vs_bridge { 'br-ex':
      ensure => present,
      require => Service['neutron-plugin-ovs-service']
    }
    
    
    class { 'neutron::agents::ovs':
      enable_tunneling => true,
      local_ip => $::ipaddress_em1,
    }
    
    
    neutron_dhcp_agent_config {
        "DEFAULT/dnsmasq_config_file":
            value => "/etc/neutron/dnsmasq-neutron.conf";
    }

    file {'/etc/neutron/dnsmasq-neutron.conf':
        content => "dhcp-option-force=26,1450",
        before => Class['neutron::agents::dhcp'],
    }
  
    class { 'neutron::agents::dhcp':
      interface_driver => 'neutron.agent.linux.interface.OVSInterfaceDriver',
    }
    
    
    class {'neutron::agents::metadata':
      auth_password => "$neutron_metadata_auth_password",
      auth_url      => "http://${private_ip}:35357/v2.0",
      shared_secret => "$neutron_metadata_shared_secret",
      metadata_ip   => "$::ipaddress_em1",
    }
}    
