node.override['gitlab-runner']['env']['RUNNER_EXECUTOR'] = 'shell' #SET RUNNER EXECUTOR
node.override['gitlab-runner']['env']['RUNNER_TAG_LIST'] = node['gitlab-runner']['env']['RUNNER_TAG_LIST'].concat(", shell")

include_recipe 'femadata-gitlab::gitlab_runner'