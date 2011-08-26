#
# Cookbook Name:: splunk
# Recipe:: deployment-Monitor-app
# 
splunk_dir = "/opt/splunk"

cookbook_file "#{splunk_dir}/etc/apps/SplunkDeploymentMonitor_for_4.2.2.tgz" do
  source "SplunkDeploymentMonitor_for_4.2.2.tgz"
end

execute "cd #{splunk_dir}/etc/apps; tar -zxvf SplunkDeploymentMonitor_for_4.2.2.tgz" do
  not_if do
    File.exists?("#{splunk_dir}/etc/apps/SplunkDeploymentMonitor/default/app.conf")
  end
  notifies :restart, resources(:service => "splunk")
end

template "#{splunk_dir}/etc/apps/SplunkDeploymentMonitor/local/app.conf" do
	source "deploy-mon-app/app.conf.erb"
	owner "root"
	group "root"
	mode "0640"
	notifies :restart, resources(:service => "splunk")
end