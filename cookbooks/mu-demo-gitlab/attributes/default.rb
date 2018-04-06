default['gitlab']['endpoint'] = "http://#{node['hostname']}/"
default['gitlab']['runner_endpoint'] = "http://#{node['hostname']}/"
default['gitlab']['gitlab_root_pwd'] = 'superman'
# default['gitlab']['runner_token'] = ''

if attribute?('ec2')
    default['gitlab']['endpoint'] = "http://#{node['ec2']['private_ip_address']}/"
    default['gitlab']['runner_endpoint'] = "http://#{node['ec2']['private_ip_address']}/"
end

# SETUP VARIABLES FOR GITLAB.RB CONFIGURATION
# default['omnibus-gitlab']['run_reconfigure'] = false
default['omnibus-gitlab']['gitlab_rb']['external_url'] = node['gitlab']['endpoint']
default['omnibus-gitlab']['gitlab_rb']['nginx']['listen_port'] = 80
default['omnibus-gitlab']['gitlab_rb']['nginx']['listen_https'] = false
default['omnibus-gitlab']['gitlab_rb']['nginx']['proxy_set_headers'] = {
    "X-Forwarded-Proto" => "https",
    "X-Forwarded-Ssl" => "on"
}
default['omnibus-gitlab']['gitlab_rb']['gitlab_rails']['time_zone'] = "UTC"
default['omnibus-gitlab']['gitlab_rb']['gitlab_rails']['backup_keep_time'] = 604800
default['omnibus-gitlab']['gitlab_rb']['gitlab_rails']['gitlab_email_enabled'] = false
default['omnibus-gitlab']['gitlab_rb']['gitlab_rails']['backup_path'] = "/var/opt/gitlab/backups"


# SET RUNNER SETTINGS
normal['gitlab-runner']['env']['RUNNER_NAME'] = node['hostname']
normal['gitlab-runner']['env']['REGISTER_NON_INTERACTIVE'] = 'true' # DON'T CHANGE THIS
normal['gitlab-runner']['env']['RUNNER_TAG_LIST'] = "mu-node, #{node['hostname']}, #{node['platform_family']}"
normal['gitlab-runner']['env']['REGISTER_LOCKED'] = 'false'
normal['gitlab-runner']['env']['REGISTER_RUN_UNTAGGED'] = 'false'
normal['gitlab-runner']['env']['RUNNER_REQUEST_CONCURRENCY'] = '100'
normal['gitlab-runner']['env']['RUNNER_LIMIT'] = '99'

default['gitlab-runner']['env']['RUNNER_EXECUTOR'] == 'docker'
default['gitlab-runner']['env']['WINDOWS_INSTALL_DIR'] = '/gitlab-runner'
default['gitlab-runner']['env']['WINDOWS_DOWNLOAD_URL'] = 'https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-windows-amd64.exe'



