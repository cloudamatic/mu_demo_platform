# frozen_string_literal: true
source 'https://supermarket.chef.io'

metadata

# Platform Cookbooks
cookbook 'demo_gitlab', path: 'site_cookbooks/demo_gitlab'
cookbook 'demo_jenkins', path: 'site_cookbooks/demo_jenkins'
cookbook 'demo_wordpress', path: 'site_cookbooks/demo_wordpress'
cookbook 'demo_elk_stack', path: 'site_cookbooks/demo_elk_stack'

# Supermarket Cookbooks
cookbook 'chef-vault', '~> 3.0.0'
cookbook 'docker', '~> 4.0.1'

# Gitlab Cookbooks
cookbook 'omnibus-gitlab', '~> 0.4.2', git: 'https://gitlab.com/gitlab-org/cookbook-omnibus-gitlab.git'
cookbook 'gitlab_secrets', '~> 0.0.6', git: 'https://gitlab.com/gitlab-cookbooks/gitlab_secrets.git'