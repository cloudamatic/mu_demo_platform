#
# Cookbook Name:: demo
# Recipe:: gitlab
#
# Copyright:: Copyright (c) 2017 eGlobalTech, Inc., all rights reserved
#
# Licensed under the BSD-3 license (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License in the root of the project or at
#
#     http://egt-labs.com/mu/LICENSE.html
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


case node['platform_family']
	when 'rhel', 'amazon'
	  #script_url = "#{node['gitlab-ci-runner']['repository_base_url']}" + "#{node['gitlab-ci-runner']['rpmScript']}"
	  script_url = 'https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh'
	when 'debian'
	  #script_url = "#{node['gitlab-ci-runner']['repository_base_url']}" + "#{node['gitlab-ci-runner']['debScript']}"
	  script_url = 'https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh'
end
	
	execute 'Configure Repositories' do
	  command "curl -L #{script_url} | sudo bash"
	end
	
	package 'gitlab-runner' do
	  action :install
	end
	
	service 'gitlab-runner' do
	  action [:enable, :start]
	end
	
	# SEARCH FOR THE GITLAB SERVER
	
	gitlab_server = ''
	gitlab_token = ''
	
	if ENV['GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN']
    # CHECK FOR ENV VARIABLES WITH INFORMATION
    gitlab_server = ENV['GITLAB_ENDPOINT']
    gitlab_token = ENV['GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN']
    gitlab_root_pwd = ENV['GITLAB_ROOT_PASSWORD']
else
    # SEARCH FOR NODE ATTRIBUTE WITH THE INFORMATION
    gitlabServers = search(:node, "gitlab_is_server:true") do |node|
        puts "GITLAB SERVER INFO FOUND!"
        gitlab_server = node['gitlab']['endpoint']
        gitlab_token = node['gitlab']['runner_token']
    end
end

	if !gitlab_token.empty? and !gitlab_server.empty?

		puts "******************************************************"
		puts gitlab_server
		puts gitlab_token
		puts "******************************************************"
		
		
		execute 'Register Runner' do
			command "gitlab-runner register -n -u '#{gitlab_server}' -r '#{gitlab_token}' --executor docker --docker-image ubuntu --locked false --tag-list '#{node['ec2']['public_dns_name']}, #{node['platform_family']}, docker'"
			notifies :restart, 'service[gitlab-runner]', :delayed
			ignore_failure true
		end
		
	else
		puts 'No Server Found...'
	end

	docker_service 'default' do
	  action [:create, :start]
	end
	