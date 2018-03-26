name 'mu-demo-gitlab'
maintainer 'eGlobalTech'
maintainer_email 'eGTLabs@eglobaltech.com'
license 'MIT'
description 'Installs/Configures GitLab CD'
long_description 'Installs/Configures GitLab CD'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'debian'

issues_url 'https://github.com/cloudamatic/mu/issues'
source_url 'https://github.com/cloudamatic/mu'


depends 'chef-vault', '~> 3.0.0'
depends 'omnibus-gitlab'
depends 'docker'
depends 'firewall'