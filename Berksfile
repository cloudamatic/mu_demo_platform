source "https://supermarket.chef.io"
source chef_repo: "cookbooks/"
begin
source :chef_server
rescue
	pp "No chef server to use as cookbook source"
end


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