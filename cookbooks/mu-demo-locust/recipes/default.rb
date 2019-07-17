#
# Cookbook:: mu-demo-locust
# Recipe:: default
#
# Copyright:: 2019, Zach Rowe, All Rights Reserved.

package 'python'

path = '/test'

if node['deployment'].has_key?('application_attributes') and node['deployment']['application_attributes'].has_key? 'test_repo'
  repo = node['deployment']['application_attributes']['test_repo']
end

execute 'install locust' do
  command 'pip install locustio'
end

directory path

git 'checkout test repo' do
  destination path
  repository repo
  not_if { repo.nil? }
end
