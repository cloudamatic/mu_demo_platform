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

require 'securerandom'
include_recipe 'chef-vault'

firewall 'default' do
    action :nothing
end

firewall_rule 'Open Gitlab Ports' do
    port     [80, 8080]
    command  :allow
    notifies :restart, 'firewall[default]', :immediately
end

gitlab_server = ''
gitlab_token = ''
gitlab_root_pwd = ''

search(:node, "gitlab_is_server:true").each do |node|
    gitlab_server = node['gitlab']['endpoint']
    gitlab_token = node['gitlab']['runnerToken']
    puts "GITLAB SERVER INFO FOUND!"
end

if gitlab_server.empty?
    # GENERATE A RUNNERTOKEN AND A ROOT PASSWORD
    puts "No GITLAB SERVER FOUND... GENERATING A TOKEN"
    gitlab_server = 'http://localhost/'
    gitlab_token = '9nvwe38cm2cm8m' #SecureRandom.urlsafe_base64
    gitlab_root_pwd = 'superman'
end

# Set an attribute to identify the node as a GitLab Server
node.override['gitlab']['is_server'] = true
node.override['gitlab']['endpoint'] = gitlab_server
node.override['gitlab']['runner_endpoint'] = "http://#{node['ec2']['public_dns_name']}/"

node.override['omnibus-gitlab']['gitlab_rb']['nginx']['listen_port'] = 80
node.override['omnibus-gitlab']['gitlab_rb']['nginx']['listen_https'] = false
node.override['omnibus-gitlab']['gitlab_rb']['nginx']['proxy_set_headers'] = {
    "X-Forwarded-Proto" => "https",
    "X-Forwarded-Ssl" => "on"
  }

# SETUP VARIABLES FOR GITLAB.RB CONFIGURATION
node.override['omnibus-gitlab']['gitlab_rb']['external_url'] = gitlab_server

# SET ENV VARIABLES TO PASS TO GITLAB AND TO THE GITLAB RUNNER
ENV['GITLAB_ENDPOINT'] = gitlab_server
ENV['GITLAB_ROOT_PASSWORD'] = gitlab_root_pwd
ENV['GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN'] = gitlab_token

include_recipe 'omnibus-gitlab::default'

