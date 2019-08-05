node.override['gitlab-runner']['env']['RUNNER_EXECUTOR'] = 'shell' #SET RUNNER EXECUTOR
node.override['gitlab-runner']['env']['RUNNER_TAG_LIST'] = node['gitlab-runner']['env']['RUNNER_TAG_LIST'] + ", shell"

include_recipe 'mu-demo-gitlab::gitlab_runner'
