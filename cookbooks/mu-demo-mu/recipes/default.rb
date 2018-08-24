#
# Cookbook:: mu-demo-mu
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# remote_file 'Download Mu Installer' do
# 	source 'https://raw.githubusercontent.com/cloudamatic/mu/master/cookbooks/mu-master/recipes/init.rb'
# 	path "#{Chef::Config[:file_cache_path]}/installer.rb"
# 	mode '0755'
# 	action :create
# end

hostname = node['ec2']['public_hostname'] || node['ec2']['private_dns_name']

# execute 'Install Mu' do
# 	command "/opt/chef/bin/chef-apply #{Chef::Config[:file_cache_path]}/init.rb -n -m mu@egt-labs.com -u 'mu master' -h #{node['hostname']} -p #{hostname}"
# 	live_stream true
# end

execute 'Install Mu' do
	command "/opt/mu/bin/mu-configure -n -m mu@egt-labs.com -u 'mu master' -h #{node['hostname']} -p #{hostname}"
	live_stream True
end

# execute 'create_user' do
# 	command <<-EOH
#     	ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
# 		admin_email="mu@eg"
# 		sed -i "s/\/opt\/mu\/bin\/mu-configure \$\@/\/opt\/mu\/bin\/mu-configure \$\@ -np $ip -m $admin_email/g" installer""" % branch
#     EOH
#   end