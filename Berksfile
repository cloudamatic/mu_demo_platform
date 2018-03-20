# frozen_string_literal: true
source 'https://supermarket.chef.io'
local_cookbook_path = "cookbooks"

metadata

# Platform Cookbooks
cookbook 'demo_gitlab', path: "#{mu_cookbook_path}/demo_gitlab"
cookbook 'demo_jenkins', path: "#{mu_cookbook_path}/demo_jenkins"
cookbook 'demo_wordpress', path: "#{mu_cookbook_path}/demo_wordpress"
cookbook 'demo_elk_stack', path: "#{mu_cookbook_path}/demo_elk_stack"

# Supermarket Cookbooks
cookbook 'chef-vault', '~> 3.0.0'
cookbook 'docker', '~> 4.0.1'
cookbook 'firewall', '~> 2.6.3'

# Gitlab Cookbooks
cookbook 'omnibus-gitlab', '~> 0.4.2', git: 'http://ec2-34-200-91-90.compute-1.amazonaws.com/ryan.bolyard/cookbook-omnibus-gitlab.git'
cookbook 'gitlab_secrets', '~> 0.0.6', git: 'https://gitlab.com/gitlab-cookbooks/gitlab_secrets.git'