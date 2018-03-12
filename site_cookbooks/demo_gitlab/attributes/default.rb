if !node['gitlab'] or !node['gitlab']['is_server']
    # ONlY SET THESE ONCE
    node.default['gitlab']['is_server'] = true
    node.default['gitlab']['runner_token'] = SecureRandom.urlsafe_base64
    node.default['gitlab']['gitlab_root_pwd'] = 'superman'
end

node.default['gitlab']['endpoint'] = "http://#{node['ec2']['private_ip_address']}/"
node.default['gitlab']['runner_endpoint'] = "http://#{node['ec2']['private_ip_address']}/"

# SETUP VARIABLES FOR GITLAB.RB CONFIGURATION
node.default['omnibus-gitlab']['gitlab_rb']['external_url'] = node['gitlab']['endpoint']
node.default['omnibus-gitlab']['gitlab_rb']['nginx']['listen_port'] = 80
node.default['omnibus-gitlab']['gitlab_rb']['nginx']['listen_https'] = false
node.default['omnibus-gitlab']['gitlab_rb']['nginx']['proxy_set_headers'] = {
    "X-Forwarded-Proto" => "https",
    "X-Forwarded-Ssl" => "on"
}






# VARIABLES FOR gITLAB RUNNER CONFIGURATION
#node.default['gitlab-runner']['env']['CI_SERVER_URL'] = gitlab_server
node.default['gitlab-runner']['env']['RUNNER_NAME'] = node['hostname']
#node.default['gitlab-runner']['env']['REGISTRATION_TOKEN'] = gitlab_token
node.default['gitlab-runner']['env']['REGISTER_NON_INTERACTIVE'] = 'true'
node.default['gitlab-runner']['env']['RUNNER_EXECUTOR'] = 'docker'
node.default['gitlab-runner']['env']['DOCKER_IMAGE'] = 'ubuntu'
node.default['gitlab-runner']['env']['REGISTER_LOCKED'] = 'false'
node.default['gitlab-runner']['env']['REGISTER_RUN_UNTAGGED'] = 'true'
node.default['gitlab-runner']['env']['RUNNER_TAG_LIST'] = "mu-node, #{node['hostname']}, #{node['platform_family']}, docker"
node.default['gitlab-runner']['env']['RUNNER_EXECUTOR'] = 'docker'
node.default['gitlab-runner']['env']['RUNNER_REQUEST_CONCURRENCY'] = '100'
node.default['gitlab-runner']['env']['RUNNER_LIMIT'] = '99'

