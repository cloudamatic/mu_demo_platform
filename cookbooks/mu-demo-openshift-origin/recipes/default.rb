#remote_file "/etc/yum.repos.d/docker-ce.repo" do
#  source "https://download.docker.com/linux/centos/docker-ce.repo"
#end
cookbook_file "/etc/yum.repos.d/redhat-rhui.repo" do
  source "redhat-rhui.repo"
end

#mu_tools_disk "/tmp" do
#  device "/dev/xvdf"
#  size 40
#  preserve_data true
#  not_if "awk '{print $2}' < /etc/mtab | grep '^/tmp$'"
#end

#rpm_package "container-selinux" do
#  source "http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.68-1.el7.noarch.rpm"
#end
#package "docker-ce"
#package "docker-ce-selinux"
package "vim"
package "ansible"
package "python2-boto3"
package "git"
package "tcpdump"
package "lsof"
package "telnet"
package "mlocate"

include_recipe 'chef-vault'

#service "docker" do
#  action [:enable, :start]
#end

bash "iptables permissiveness for Docker" do
  code <<-EOH
    /sbin/iptables -P INPUT ACCEPT
    /sbin/iptables -P FORWARD ACCEPT
  EOH
end
# something keeps stepping on these
cron "fix iptables policies" do
  command "/sbin/iptables -P INPUT ACCEPT; /sbin/iptables -P FORWARD ACCEPT"
end
#execute "echo '/sbin/iptables -P INPUT ACCEPT' >> /etc/rc.d/rc.local" do
#  not_if "grep '^/sbin/iptables -P INPUT ACCEPT' /etc/rc.d/rc.local"
#end
#execute "echo '/sbin/iptables -P FORWARD ACCEPT' >> /etc/rc.d/rc.local" do
#  not_if "grep '^/sbin/iptables -P FORWARD ACCEPT' /etc/rc.d/rc.local"
#end

bash "enable IP forwarding" do
  code <<-EOH
    sysctl -w net.ipv4.ip_forward=1
    if ! grep 'net.ipv4.ip_forward = 1' /etc/sysctl.conf;then
      sed -i 's/net.ipv4.ip_forward .*/net.ipv4.ip_forward = 1/' /etc/sysctl.conf
    fi
  EOH
end

publickey = (chef_vault_item("openshift-origin-ssh", "public"))['file-content']
execute "echo '#{publickey}' >> /home/ec2-user/.ssh/authorized_keys" do
  only_if "grep '^#{publickey}$' /home/ec2-user/.ssh/authorized_keys"
end

bash "explicitly allow Docker traffic forwarding" do
  code <<-EOH
    /sbin/iptables -A FORWARD -i docker0 -o eth0 -j ACCEPT
    /sbin/iptables -A FORWARD -i eth0 -o docker0 -j ACCEPT
  EOH
  only_if "/sbin/ifconfig | grep docker0"
end

if node['deployment']['ssh_public_key']
  execute "echo '#{node['deployment']['ssh_public_key']}' >> /home/ec2-user/.ssh/authorized_keys" do
    not_if "grep '#{node['deployment']['ssh_public_key']}' /home/ec2-user/.ssh/authorized_keys"
  end
end
