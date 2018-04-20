# Try installing Docker. If it doesn't work the Docker Cookbook should work
node.override['gitlab-runner']['env']['RUNNER_EXECUTOR'] = 'docker' #SET RUNNER EXECUTOR
node.override['gitlab-runner']['env']['DOCKER_IMAGE'] = 'ubuntu'
node.override['gitlab-runner']['env']['RUNNER_TAG_LIST'] = node['gitlab-runner']['env']['RUNNER_TAG_LIST'].concat(", docker")

include_recipe 'mu-demo-gitlab::gitlab_runner'

package 'docker-io' do
	action :upgrade
	ignore_failure true
end

docker_service 'default' do
  action [:create, :start]
end

