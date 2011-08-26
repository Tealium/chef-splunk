#source files
default[:splunk][:unix_app]			                = "(unix.tar.gz)"

#indexer configuration attributes
default[:splunk][:indexer_name]                 = "splunk_indexers"

#directories
default[:splunk][:forwarder_home]               = "/opt/splunkforwarder"
default[:splunk][:server_home]                  = "/opt/splunk"

#web config
default[:splunk][:web_server_port]              = "80"
default[:splunk][:use_ssl]                      = true
default[:splunk][:sample_dashboard_apache]      = false

#configuration values for forwarders
default[:splunk][:receiver_port]                = "9997"
default[:splunk][:limits_thruput]               = "256"

#Change the default admin password
default[:splunk][:auth]                         = "admin:ChangeMeToSomething"

#set the role of your splunk indexer
default[:splunk][:server_role]                  = "splunk-server"

##Set the Splunk Version to be used
#Server
default[:splunk][:server_root]                  = "http://download.splunk.com/releases/"
default[:splunk][:server_version]               = "4.2.2"
default[:splunk][:server_build]                 = "101277"
#Forwarder
default[:splunk][:forwarder_root]               = "http://download.splunk.com/releases/"
default[:splunk][:forwarder_version]            = "4.2.2"
default[:splunk][:forwarder_build]              = "101277"
