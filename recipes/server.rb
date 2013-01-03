#
# Cookbook Name::splunk
# Recipe::server
#
# Copyright 2011-2012, BBY Solutions, Inc.
# Copyright 2011-2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
service "splunk" do
  action [ :nothing ]
  supports  :status => true, :start => true, :stop => true, :restart => true
end

splunk_cmd = "#{node['splunk']['server_home']}/bin/splunk"
splunk_package_version = "splunk-#{node['splunk']['server_version']}-#{node['splunk']['server_build']}"

splunk_file = splunk_package_version + 
  case node['platform']
  when "centos","redhat","fedora"
    if node['kernel']['machine'] == "x86_64"
      "-linux-2.6-x86_64.rpm"
    else
      ".i386.rpm"
    end
  when "debian","ubuntu"
    if node['kernel']['machine'] == "x86_64"
      "-linux-2.6-amd64.deb"
    else
      "-linux-2.6-intel.deb"
    end
  end

remote_file "#{Chef::Config['file_cache_path']}/#{splunk_file}" do
  source "#{node['splunk']['server_root']}/#{node['splunk']['server_version']}/splunk/linux/#{splunk_file}"
  action :create_if_missing
end

package splunk_package_version do
  source "#{Chef::Config['file_cache_path']}/#{splunk_file}"
  case node['platform']
  when "centos","redhat","fedora"
    provider Chef::Provider::Package::Rpm
  when "debian","ubuntu"
    provider Chef::Provider::Package::Dpkg
  end
end


template "#{node['splunk']['server_home']}/etc/splunk-launch.conf" do
    source "server/splunk-launch.conf.erb"
    mode "0640"
    owner "root"
    group "root"
end

if node['splunk']['use_ssl'] == true
  
  directory "#{node['splunk']['server_home']}/ssl" do
    owner "root"
    group "root"
    mode "0755"
    action :create
    recursive true
  end

  cookbook_file "#{node['splunk']['server_home']}/ssl/#{node['splunk']['ssl_crt']}" do
    source "ssl/#{node['splunk']['ssl_crt']}"
    mode "0755"
    owner "root"
    group "root"
  end

  cookbook_file "#{node['splunk']['server_home']}/ssl/#{node['splunk']['ssl_key']}" do
    source "ssl/#{node['splunk']['ssl_key']}"
    mode "0755"
    owner "root"
    group "root"
  end

end

if node['splunk']['ssl_forwarding'] == true

  # Create the SSL Cert Directory for the Forwarders
  directory "#{node['splunk']['server_home']}/etc/auth/forwarders" do
    owner "root"
    group "root"
    action :create
    recursive true
  end

  # Copy over the SSL Certs
  [node['splunk']['ssl_forwarding_cacert'],node['splunk']['ssl_forwarding_servercert']].each do |cert|
    cookbook_file "#{node['splunk']['server_home']}/etc/auth/forwarders/#{cert}" do
      source "ssl/forwarders/#{cert}"
      owner "root"
      group "root"
      mode "0755"
      notifies :restart, resources(:service => "splunk")
    end
  end

  # SSL passwords are encrypted when splunk reads the file.  We need to save the password.
  # We need to save the password if it has changed so we don't keep restarting splunk.
  # Splunk encrypted passwords always start with $1$
  ruby_block "Saving Encrypted Password (inputs.conf)" do
    block do
      inputsPass = `grep -m 1 "password = " #{node['splunk']['server_home']}/etc/system/local/inputs.conf | sed 's/password = //'`
      if inputsPass.match(/^\$1\$/) && inputsPass != node['splunk']['inputsSSLPass']
        node['splunk']['inputsSSLPass'] = inputsPass
        node.save
      end
    end
  end
end

execute "#{splunk_cmd} enable boot-start --accept-license --answer-yes" do
  not_if do
    File.symlink?('/etc/rc3.d/S20splunk') ||
    File.symlink?('/etc/rc3.d/S90splunk')
  end
end

splunk_password = node['splunk']['auth'].split(':')[1]
execute "#{splunk_cmd} edit user admin -password #{splunk_password} -roles admin -auth admin:changeme && echo true > /opt/splunk_setup_passwd" do
  not_if do
    File.exists?("/opt/splunk_setup_passwd")
  end
end

execute "#{splunk_cmd} enable listen #{node['splunk']['receiver_port']} -auth #{node['splunk']['auth']}" do
  not_if "netstat -an | grep #{node['splunk']['receiver_port']}"
end

if node['splunk']['scripted_auth'] == true
  # Be sure to deploy the authentication template.
  node['splunk']['static_server_configs'] << "authentication"

  if !node['splunk']['data_bag_key'].empty?
    scripted_auth_creds = Chef::EncryptedDataBagItem.load(node['splunk']['scripted_auth_data_bag_group'], node['splunk']['scripted_auth_data_bag_name'], node['splunk']['data_bag_key'])
  else
    scripted_auth_creds = { "user" => "", "password" => ""}
  end
  
  directory "#{node['splunk']['server_home']}/#{node['splunk']['scripted_auth_directory']}" do
    recursive true
    action :create
  end
  
  node['splunk']['scripted_auth_files'].each do |auth_file|
    cookbook_file "#{node['splunk']['server_home']}/#{node['splunk']['scripted_auth_directory']}/#{auth_file}" do
      source "scripted_auth/#{auth_file}"
      owner "root"
      group "root"
      mode "0755"
      action :create
    end
  end
  
  node['splunk']['scripted_auth_templates'].each do |auth_templ|
    template "#{node['splunk']['server_home']}/#{node['splunk']['scripted_auth_directory']}/#{auth_templ}" do
      source "server/scripted_auth/#{auth_templ}.erb"
      owner "root"
      group "root"
      mode "0744"
      variables(
        :user => scripted_auth_creds['user'],
        :password => scripted_auth_creds['password']
      )
    end
  end
end

node['splunk']['static_server_configs'].each do |cfg|
    template "#{node['splunk']['server_home']}/etc/system/local/#{cfg}.conf" do
     	source "server/#{cfg}.conf.erb"
     	owner "root"
     	group "root"
     	mode "0640"
      notifies :restart, resources(:service => "splunk")
     end
end

node['splunk']['dynamic_server_configs'].each do |cfg|
  template "#{node['splunk']['server_home']}/etc/system/local/#{cfg}.conf" do
   	source "server/#{node['splunk']['server_config_folder']}/#{cfg}.conf.erb"
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
end

directory "#{node['splunk']['server_home']}/etc/users/admin/search/local/data/ui/views" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

if node['splunk']['deploy_dashboards'] == true
  node['splunk']['dashboards_to_deploy'].each do |dashboard|
    cookbook_file "#{node['splunk']['server_home']}/etc/users/admin/search/local/data/ui/views/#{dashboard}.xml" do
      source "dashboards/#{dashboard}.xml"
    end
  end
end

service "splunk" do
   action :start
end