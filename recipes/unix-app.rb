#
# Cookbook Name:: splunk
# Recipe:: unix-app
# 
if node.run_list.roles.include?("#{node[:splunk][:server_role]}")
  splunk_dir = "/opt/splunk"
else
  splunk_dir = "/opt/splunkforwarder"
end

cookbook_file "#{splunk_dir}/etc/apps/unix.tar.gz" do
  source "unix.tar.gz"
end

execute "cd #{splunk_dir}/etc/apps; tar -zxvf unix.tar.gz" do
  not_if do
    File.exists?("#{splunk_dir}/etc/apps/unix/default/inputs.conf")
  end
  notifies :restart, resources(:service => "splunk")
end

["inputs","app"].each do |cfg|
  template "#{splunk_dir}/etc/apps/unix/local/#{cfg}.conf" do
   	source "unix-app/#{cfg}.conf.erb"
   	owner "root"
   	group "root"
   	mode "0640"
    notifies :restart, resources(:service => "splunk")
   end
end