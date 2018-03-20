# frozen_string_literal: true
source 'https://supermarket.chef.io'
cookbook_path = "cookbooks"

metadata

# Platform Cookbooks
cookbook 'mu-demo-gitlab', path: "#{cookbook_path}/mu-demo-gitlab"
cookbook 'mu-demo-jenkins', path: "#{cookbook_path}/mu-demo-jenkins"
cookbook 'mu-demo-wordpress', path: "#{cookbook_path}/mu-demo-wordpress"
cookbook 'mu-demo-elk_stack', path: "#{cookbook_path}/mu-demo-elk_stack"

# Supermarket Cookbooks
cookbook 'chef-vault', '~> 3.0.0'
cookbook 'docker', '~> 4.0.1'
cookbook 'firewall', '~> 2.6.3'

# Gitlab Cookbooks
cookbook 'omnibus-gitlab', '~> 0.4.2', git: 'http://ec2-34-200-91-90.compute-1.amazonaws.com/ryan.bolyard/cookbook-omnibus-gitlab.git'
cookbook 'gitlab_secrets', '~> 0.0.6', git: 'https://gitlab.com/gitlab-cookbooks/gitlab_secrets.git'