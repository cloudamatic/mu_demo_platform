name 'mu-demo-wordpress'
maintainer 'eGlobalTech'
maintainer_email 'eGTLabs@eglobaltech.com'
license 'MIT'
description 'Installs/Configures wordpress'
long_description 'Installs/Configures wordpress'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'debian'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/cloudamatic/mu/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/cloudamatic/mu'
