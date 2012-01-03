# Name of the cookbook (referenced in forwarder.rb)
set[:splunk][:cookbook_name]                = "splunk-cookbook"

#indexer configuration attributes
set[:splunk][:indexer_name]                 = "splunk_indexers"

#directories
set[:splunk][:forwarder_home]               = "/opt/splunkforwarder"
set[:splunk][:server_home]                  = "/opt/splunk"
set[:splunk][:db_directory]                 = "/volr/splunk"

#web config
set[:splunk][:web_server_port]              = "443"
set[:splunk][:browser_timeout]              = "0"
set[:splunk][:minify_js]                    = "true"
set[:splunk][:minify_css]                   = "true"

set[:splunk][:use_ssl]                      = true
set[:splunk][:ssl_crt]                      = "ssl.crt"
set[:splunk][:ssl_key]                      = "ssl.key"

# Dashboards to deploy
set[:splunk][:dashboards_to_deploy]         = ["apache_http","useragents"]

# Static Server Configs (Configs that match regardless of environment -Dev,QA,PL,Prod,Etc)
set[:splunk][:static_server_configs]        = ["web","transforms"]

# Dynamic Server Configs (Configs that change per environment)
set[:splunk][:dynamic_server_configs]       = ["inputs","props"]

#configuration values for forwarders
set[:splunk][:receiver_port]                = "9997"
set[:splunk][:limits_thruput]               = "256"

#Change the default admin password (Username::Password)
set[:splunk][:auth]                         = "admin:SomePassword123!!"

#set the role of your splunk indexer
set[:splunk][:server_role]                  = "splunk-server"

#set the default role for splunk forwarders
set[:splunk][:forwarder_role]               = "default"
set[:splunk][:forwarder_config_folder]      = "prodlike"
set[:splunk][:server_config_folder]         = "prodlike"

##Set the Splunk Version to be used
#Server
set[:splunk][:server_root]                  = "http://download.splunk.com/releases"
set[:splunk][:server_version]               = "4.2.5"
set[:splunk][:server_build]                 = "113966"
#Forwarder
set[:splunk][:forwarder_root]               = "http://download.splunk.com/releases"
set[:splunk][:forwarder_version]            = "4.2.5"
set[:splunk][:forwarder_build]              = "113966"

# Unix app version number 
set[:splunk][:unix_app_file]                = "unix.tar.gz"
set[:splunk][:unix_app_version]             = "4.5"

# PDF Server version number
set[:splunk][:pdf_server_file]              = "pdfserver.tar.gz"
set[:splunk][:pdf_server_version]           = "1.3"

# Deployment Monitor Version Number
set[:splunk][:deployment_mon_file]          = "SplunkDeploymentMonitor.tar.gz"
set[:splunk][:deployment_mon_version]       = "4.2.2"

# Splunk SOS app
set[:splunk][:splunk_sos_file]              = "sos.tar.gz"
set[:splunk][:splunk_sos_version]           = "2.0.0"

# Splunk SOS Required App
set[:splunk][:sideview_file]                = "sideview_utils.tar.gz"
set[:splunk][:sideview_version]             = "1.2.5"