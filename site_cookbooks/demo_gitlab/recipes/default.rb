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



# IF WE HAVEN'T FOUND INFORMATION GENERATE THE INFORMATION
if !node['gitlab'] or !node['gitlab']['is_server']
    puts "Not A gitlab Server Yet..."
    gitlab_server = 'http://localhost/'
    gitlab_token = '9nvwe38cm2cm8m' #SecureRandom.urlsafe_base64
    gitlab_root_pwd = 'superman'

    # ONlY SET THESE IF WE ARE MAKING A CHANGE
    node.default['gitlab']['is_server'] = true
    node.default['gitlab']['endpoint'] = 'http://localhost/'
    node.default['gitlab']['runner_endpoint'] = "http://#{node['ec2']['public_dns_name']}/"
    node.default['gitlab']['runner_token'] = '9nvwe38cm2cm8m' #SecureRandom.urlsafe_base64
    node.default['gitlab']['gitlab_root_pwd'] = 'superman'

    # SET ENV VARIABLES TO PASS TO GITLAB AND TO THE GITLAB RUNNER
    ENV['GITLAB_ENDPOINT'] = node['gitlab']['endpoint']
    ENV['GITLAB_ROOT_PASSWORD'] = node['gitlab']['gitlab_root_pwd']
    ENV['GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN'] = node['gitlab']['runner_token']
end



# SETUP VARIABLES FOR GITLAB.RB CONFIGURATION
node.default['omnibus-gitlab']['gitlab_rb']['external_url'] = node['gitlab']['endpoint']
node.default['omnibus-gitlab']['gitlab_rb']['nginx']['listen_port'] = 80
node.default['omnibus-gitlab']['gitlab_rb']['nginx']['listen_https'] = false
node.default['omnibus-gitlab']['gitlab_rb']['nginx']['proxy_set_headers'] = {
    "X-Forwarded-Proto" => "https",
    "X-Forwarded-Ssl" => "on"
  }

include_recipe 'omnibus-gitlab::default'



