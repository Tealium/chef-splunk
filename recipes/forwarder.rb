#
# Cookbook Name:: splunk
# Recipe:: forwarder_new
#
#

directory "/opt" do
  mode "0755"
  owner "root"
  group "root"
end

splunk_cmd = "#{node[:splunk][:forwarder_home]}/bin/splunk"
splunk_package_version = "splunkforwarder-#{node[:splunk][:forwarder_version]}-#{node[:splunk][:forwarder_build]}"

splunk_file = splunk_package_version + 
  case node[:platform]
  when "centos","redhat","fedora"
    if node[:kernel][:machine] == "x86_64"
      "-linux-2.6-x86_64.rpm"
    else
      ".i386.rpm"
    end
  when "debian","ubuntu"
    if node[:kernel][:machine] == "x86_64"
      "-linux-2.6-amd64.deb"
    else
      "-linux-2.6-intel.deb"
    end
  end

remote_file "/opt/#{splunk_file}" do
  source "#{node[:splunk][:forwarder_root]}/#{node[:splunk][:forwarder_version]}/universalforwarder/linux/#{splunk_file}"
  action :create_if_missing
end

package splunk_package_version do
  source "/opt/#{splunk_file}"
  case node[:platform]
  when "centos","redhat","fedora"
    provider Chef::Provider::Package::Rpm
  when "debian","ubuntu"
    provider Chef::Provider::Package::Dpkg
  end
end

execute "#{splunk_cmd} start --accept-license --answer-yes" do
  not_if "#{node[:splunk][:forwarder_home]}/bin/splunk status | grep 'splunkd is running'"
end

execute "#{splunk_cmd} enable boot-start" do
  not_if do
    File.symlink?('/etc/rc4.d/S20splunk')
  end
end

service "splunk" do
  action [ :nothing ]
  supports :status => true, :start => true, :stop => true, :restart => true
end

splunk_password = node[:splunk][:auth].split(':')[1]
execute "#{splunk_cmd} edit user admin -password #{splunk_password} -roles admin -auth admin:changeme && echo true > /opt/splunk_setup_passwd" do
  not_if do
    File.exists?("/opt/splunk_setup_passwd")
  end
end

splunk_servers = search(:node, "role:#{node[:splunk][:server_role]}")

template "#{node[:splunk][:forwarder_home]}/etc/system/local/outputs.conf" do
	source "forwarder/outputs.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	variables :splunk_servers => splunk_servers
	notifies :restart, resources(:service => "splunk")
end

["inputs","limits"].each do |cfg|
  template "#{node[:splunk][:forwarder_home]}/etc/system/local/#{cfg}.conf" do
   	source "forwarder/#{cfg}.conf.erb"
   	owner "root"
   	group "root"
   	mode "0640"
    notifies :restart, resources(:service => "splunk")
   end
end

template "/etc/init.d/splunk" do
  source "forwarder/splunk.erb"
  mode "0755"
  owner "root"
  group "root"
  variables :splunk_cmd => splunk_cmd
end

# We own splunk with root, this won't work on Ubuntu because of secure_path  
#  template "/etc/profile.d/splunk.sh" do
#      source "profile-d-sh.erb"
#      mode "0755"
#      owner "root"
#      group "root"
#  end
