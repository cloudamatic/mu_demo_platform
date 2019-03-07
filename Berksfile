# Default Chef Supermarket
source "https://supermarket.chef.io"
# Use Chef Server if you can
if File.file?('/etc/chef/client.pem')
	source :chef_server
end
# this repo as a cookbook source
source chef_repo: "cookbooks/"

metadata

# Platform Cookbooks
cookbook 'mu-demo-gitlab'
cookbook 'mu-demo-jenkins'
cookbook 'mu-demo-wordpress'
cookbook 'mu-demo-elk_stack'

# Supermarket Cookbooks
cookbook 'chef-vault', '~> 3.0.0'
cookbook 'docker', '~> 4.0.1'
cookbook 'firewall', '~> 2.6.3'