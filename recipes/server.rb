#
# Cookbook Name::splunk
# Recipe::server
#
#

directory "/opt" do
  mode "0755"
  owner "root"
  group "root"
end

splunk_cmd = "#{node[:splunk][:server_home]}/bin/splunk"
splunk_package_version = "splunk-#{node[:splunk][:server_version]}-#{node[:splunk][:server_build]}"

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
  source "#{node[:splunk][:server_root]}/#{node[:splunk][:server_version]}/splunk/linux/#{splunk_file}"
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
  not_if "#{node[:splunk][:server_home]}/bin/splunk status | grep 'splunkd is running'"
end

execute "#{splunk_cmd} enable boot-start" do
  not_if do
    File.symlink?('/etc/rc3.d/S20splunk')
  end
end

service "splunk" do
  action [ :nothing ]
  supports  :status => true, :start => true, :stop => true, :restart => true
end

splunk_password = node[:splunk][:auth].split(':')[1]
execute "#{splunk_cmd} edit user admin -password #{splunk_password} -roles admin -auth admin:changeme && echo true > /opt/splunk_setup_passwd" do
  not_if do
    File.exists?("/opt/splunk_setup_passwd")
  end
end

execute "#{splunk_cmd} enable listen #{node[:splunk][:receiver_port]} -auth #{node[:splunk][:auth]}" do
  not_if "netstat -a | grep #{node[:splunk][:receiver_port]}"
end

["inputs","web","props"].each do |cfg|
  template "#{node[:splunk][:server_home]}/etc/system/local/#{cfg}.conf" do
    source "server/#{cfg}.conf.erb"
    owner "root"
    group "root"
    mode "0640"
    notifies :restart, resources(:service => "splunk")
  end
end

template "/etc/init.d/splunk" do
  source "server/splunk.erb"
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

directory "#{node[:splunk][:server_home]}/etc/users/admin/search/local/data/ui/views" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end
  
if node[:splunk][:sample_dashboard_apache] == true
  cookbook_file "#{node[:splunk][:server_home]}/etc/users/admin/search/local/data/ui/views/apache_http.xml" do
    source "dashboards/apache_http.xml"
  end
end 
