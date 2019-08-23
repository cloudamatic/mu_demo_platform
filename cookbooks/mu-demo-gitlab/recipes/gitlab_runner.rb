#
# Cookbook:: demo
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



# Since I want to assume docker is the default I am putting this here so that it builds docker if you just run the gitlab_runner recipe
if node['gitlab-runner']['env']['RUNNER_EXECUTOR'] == 'docker'
	node.override['gitlab-runner']['env']['DOCKER_IMAGE'] = 'ubuntu'
	node.override['gitlab-runner']['env']['RUNNER_TAG_LIST'] = node['gitlab-runner']['env']['RUNNER_TAG_LIST'].concat(", docker")

	package 'docker-io' do
		action :upgrade
		ignore_failure true
	end

	docker_service 'default' do
		action [:create, :start]
	end
end 

runner_executable = 'gitlab-runner'

case node['platform']
when 'linux'
	node.override['gitlab-runner']['env']['RUNNER_TAG_LIST'] = node['gitlab-runner']['env']['RUNNER_TAG_LIST'].concat(", #{node['platform']}")

	case node['platform_family']
	when 'rhel', 'amazon'
		script_url = 'https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh'
	when 'debian'
		script_url = 'https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh'
	end

	execute 'Configure Repositories' do
		command "curl -L #{script_url} | sudo bash"
		not_if "#{runner_executable} status"
	end

	package 'gitlab-runner' do
		action :upgrade
	end

when 'windows'
	runner_exe = "#{node['gitlab-runner']['env']['WINDOWS_INSTALL_DIR']}/gitlab-runner.exe"
	runner_executable = runner_exe

	directory node['gitlab-runner']['env']['WINDOWS_INSTALL_DIR'] do
		action :create
	end

	remote_file runner_exe do
		source node['gitlab-runner']['env']['WINDOWS_DOWNLOAD_URL']
	end

	execute 'Install Runner' do
		command "#{runner_exe} install && #{runner_exe} start"
		not_if "#{runner_executable} status"
	end



end

service 'gitlab-runner' do
  action [:enable, :start]
end

# SEARCH FOR THE GITLAB SERVER
gitlab_server = ''
gitlab_token = ''

if ENV['GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN']
# CHECK FOR ENV VARIABLES WITH INFORMATION
gitlab_server = ENV['GITLAB_RUNNER_ENDPOINT']
gitlab_token = ENV['GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN']
	puts "GITLAB SERVER INFO FOUND IN ENV VARIABLES!"
else
		# SEARCH FOR NODE ATTRIBUTE WITH THE INFORMATION
		search(:node, "gitlab_is_server:true") do |node|
				gitlab_server = node['gitlab']['runner_endpoint']
				gitlab_token = node['gitlab']['runner_token']
				puts "GITLAB SERVER INFO FOUND IN NODE ATTRIBUTES!"
		end
end

if !gitlab_token.empty? and !gitlab_server.empty?

	puts "******************************************************"
	puts node['hostname']
	puts gitlab_server
	# puts gitlab_token
	puts "******************************************************"
	
	# SET ENV VARIABLES TO PASS TO GITLAB AND TO THE GITLAB RUNNER
	ENV['CI_SERVER_URL'] = gitlab_server
	ENV['REGISTRATION_TOKEN'] = gitlab_token

	# LOOP THROUGH THE ENV ATTRIBUTES, and DROP THEM INTO ACTUAL ATTRIBUTE VARIABLES
	node['gitlab-runner']['env'].each do |key, value|
		if !value.nil?
			ENV[key] = value
		end
	end

	execute 'Uninstall Runner' do
		command "#{runner_executable} verify -n #{node['hostname']} --delete"
		action :nothing
	end

	execute 'Register Runner' do
		command "#{runner_executable} register"
		not_if "#{runner_executable} verify -n #{node['hostname']}"
		notifies :run, 'execute[Uninstall Runner]', :before
		notifies :restart, 'service[gitlab-runner]', :delayed
	end
	
else
	puts 'No Server Found...'
end
