# Common trystack configurations

class trystack(){
  require ntp
  file {"/etc/hosts":
        ensure => present,
        source => 'puppet:///modules/trystack/hosts',
  }
  file {"/root/.ssh/":
        ensure => directory,
        mode   => 700,
  }
  file {"/root/.ssh/authorized_keys":
        ensure => present,
        mode   => 600,
        source => 'puppet:///modules/trystack/ssh_authorized_keys',
  }

  file_line { 'puppet_report_on':
    path    => '/etc/puppet/puppet.conf',
    match   => '^[ ]*report[ ]*=',
    line    => "    report = true",
  }

  #file_line { 'puppet_pluginsync_on':
  #  path    => '/etc/puppet/puppet.conf',
  #  match   => '^[ ]*pluginsync=',
  #  line    => "    pluginsync=true",
  #}


  class { 'munin::client': allow => '10.100.0.1'}

    firewall { '001 munin incoming':
        proto    => 'tcp',
        dport    => ['4949'],
        iniface  => 'em1',
        action   => 'accept',
    }

}
