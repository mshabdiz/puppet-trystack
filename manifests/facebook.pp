class trystack::facebook() {

    file {'/usr/lib/python2.6/site-packages/horizon/templates/splash.html':
#        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/lib/python2.6/site-packages/horizon/templates/splash.html',
    }
    file {'/usr/lib/python2.6/site-packages/horizon/templates/auth/login.html':
#        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/lib/python2.6/site-packages/horizon/templates/auth/login.html',
    }
    file {'/usr/lib/python2.6/site-packages/horizon/templates/auth/_login.html':
#        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/lib/python2.6/site-packages/horizon/templates/auth/_login.html',
    }
    file {'/usr/share/openstack-dashboard/openstack_dashboard/settings.py':
#        require => Package['openstack-dashboard'],
        content => template('trystack/settings.py.erb'),
    }
    file {'/usr/share/openstack-dashboard/openstack_dashboard/urls.py':
#        require => Package['openstack-dashboard'],
        source => 'puppet:///modules/trystack/usr/share/openstack-dashboard/openstack_dashboard/urls.py',
    }
}
