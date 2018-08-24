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
	command "#{Chef::Config[:file_cache_path]}/installer"
end