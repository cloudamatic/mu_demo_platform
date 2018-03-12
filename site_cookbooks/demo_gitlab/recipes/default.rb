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

if !node['gitlab'] or !node['gitlab']['is_server']
    # ONlY SET THESE ONCE
    node.default['gitlab']['is_server'] = true
    node.default['gitlab']['runner_token'] = SecureRandom.urlsafe_base64
    node.default['gitlab']['gitlab_root_pwd'] = 'superman'
end

firewall 'default' do
    action :nothing
end

firewall_rule 'Open Gitlab Ports' do
    port     [80, 8080]
    command  :allow
    notifies :restart, 'firewall[default]', :immediately
end

# SET ENV VARIABLES TO PASS TO GITLAB AND TO THE GITLAB RUNNER
ENV['GITLAB_ENDPOINT'] = node['gitlab']['endpoint']
ENV['GITLAB_RUNNER_ENDPOINT'] = node['gitlab']['runner_endpoint']
ENV['GITLAB_ROOT_PASSWORD'] = node['gitlab']['gitlab_root_pwd']
ENV['GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN'] = node['gitlab']['runner_token']

include_recipe 'omnibus-gitlab::default'



