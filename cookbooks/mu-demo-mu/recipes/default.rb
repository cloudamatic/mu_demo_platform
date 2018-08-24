#
# Cookbook:: mu-demo-mu
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

remote_file 'Download Mu Installer' do
	source 'https://raw.githubusercontent.com/cloudamatic/mu/master/install/installer'
	path "#{Chef::Config[:file_cache_path]}/installer"
	mode '0755'
	action :create
end

execute 'Install Mu' do
	command "#{Chef::Config[:file_cache_path]}/installer -n -m mu@egt-labs.com -u 'mu master' -h #{node['hostname']} -p #{node['ipaddress']p}"
end

# execute 'create_user' do
# 	command <<-EOH
#     	ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
# 		admin_email="mu@eg"
# 		sed -i "s/\/opt\/mu\/bin\/mu-configure \$\@/\/opt\/mu\/bin\/mu-configure \$\@ -np $ip -m $admin_email/g" installer""" % branch
#     EOH
#   end