# Default Chef Supermarket
source "https://supermarket.chef.io"
# Use Chef Server if you can
source :chef_server if File.file?('/etc/chef/client.pem')
# this repo as a cookbook source
source chef_repo: "cookbooks/"

# Platform Cookbooks
cookbook 'mu-demo-gitlab'
cookbook 'mu-demo-jenkins'
cookbook 'mu-demo-wordpress'
cookbook 'mu-demo-elk_stack'

# Supermarket Cookbooks
cookbook 'chef-vault', '~> 3.1.1'
cookbook 'docker', '~> 4.0.1'
cookbook 'firewall', '~> 2.6.3'
