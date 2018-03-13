default['gitlab']['endpoint'] = "http://#{node['hostname']}/"
default['gitlab']['runner_endpoint'] = "http://#{node['hostname']}/"
default['gitlab']['gitlab_root_pwd'] = 'superman'

if attribute?('ec2')
    default['gitlab']['endpoint'] = "http://#{node['ec2']['private_ip_address']}/"
    default['gitlab']['runner_endpoint'] = "http://#{node['ec2']['private_ip_address']}/"
end

# SETUP VARIABLES FOR GITLAB.RB CONFIGURATION
default['omnibus-gitlab']['gitlab_rb']['external_url'] = node['gitlab']['endpoint']
default['omnibus-gitlab']['gitlab_rb']['nginx']['listen_port'] = 80
default['omnibus-gitlab']['gitlab_rb']['nginx']['listen_https'] = false
default['omnibus-gitlab']['gitlab_rb']['nginx']['proxy_set_headers'] = {
    "X-Forwarded-Proto" => "https",
    "X-Forwarded-Ssl" => "on"
}






# VARIABLES FOR gITLAB RUNNER CONFIGURATION




# SET RUNNER SETTINGS
#default['gitlab-runner']['env']['CI_SERVER_URL'] = gitlab_server
#default['gitlab-runner']['env']['REGISTRATION_TOKEN'] = gitlab_token
default['gitlab-runner']['env']['RUNNER_NAME'] = node['hostname']
default['gitlab-runner']['env']['REGISTER_NON_INTERACTIVE'] = 'true' # DON'T CHANGE THIS


default['gitlab-runner']['env']['RUNNER_EXECUTOR'] = 'docker' #SET RUNNER EXECUTOR

# CONFIGURE DOCKER SETTINGS
default['gitlab-runner']['env']['DOCKER_IMAGE'] = 'ubuntu'
default['gitlab-runner']['env']['REGISTER_LOCKED'] = 'false'
default['gitlab-runner']['env']['REGISTER_RUN_UNTAGGED'] = 'true'
default['gitlab-runner']['env']['RUNNER_TAG_LIST'] = "mu-node, #{node['hostname']}, #{node['platform_family']}, docker"
default['gitlab-runner']['env']['RUNNER_EXECUTOR'] = 'docker'
default['gitlab-runner']['env']['RUNNER_REQUEST_CONCURRENCY'] = '100'
default['gitlab-runner']['env']['RUNNER_LIMIT'] = '99'

# ONlY SET THESE IF NOTHING IS SET EXPLICITY
puts node['gitlab']
if !node['gitlab'].has_key?('runner_token')
    puts "###################### Generating Runner Token DOESNT EXIST ######################"
    override['gitlab']['runner_token'] = SecureRandom.urlsafe_base64
end
if node['gitlab']['runner_token'].empty?
    puts "###################### Generating Runner Token EMPTY ######################"
    override['gitlab']['runner_token'] = SecureRandom.urlsafe_base64
end


if !node['gitlab'].has_key?('gitlab_root_pwd') or node['gitlab']['gitlab_root_pwd'].empty?
    puts "###################### Generating Root Password ######################"
    override['gitlab']['gitlab_root_pwd'] = SecureRandom.urlsafe_base64
end