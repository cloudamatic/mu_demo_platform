#
# Cookbook:: mu-demo-locust
# Recipe:: default
#
# Copyright:: 2019, Zach Rowe, All Rights Reserved.

package 'python'

path = '/test'

unless node['deployment']['application_attributes']['test_repo'].empty?
  repo = node['deployment']['application_attributes']['test_repo']
end

execute 'install locust' do
  command 'pip install locustio'
end

directory path do
  action :nothing
end

git 'checkout test repo' do
  destination path
  repository repo
  not_if { repo.nil? }
  notifies :create, "directory[#{path}]", :before
end
