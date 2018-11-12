execute "git clone https://github.com/openshift/openshift-ansible" do
  cwd "/root"
  not_if "test -d /root/openshift-ansible"
end

execute "cd /root/openshift-ansible && git checkout release-3.11"

template "/etc/ansible/hosts" do
  source "inventory.erb"
  variables(
    :bind_dn => (chef_vault_item("mu_ldap", "mu_bind_acct"))['username'],
    :bind_pw => (chef_vault_item("mu_ldap", "mu_bind_acct"))['password']
  )
end

privatekey = (chef_vault_item("openshift-origin-ssh", "private"))['file-content']
file "/root/.ssh/id_rsa" do
  content privatekey
  mode 0600
end
