# Name of the cookbook (referenced in forwarder.rb)
default['splunk']['cookbook_name']                = "splunk"

#indexer configuration attributes
default['splunk']['indexer_name']                 = "splunk_indexers"

#directories
default['splunk']['forwarder_home']               = "/opt/splunkforwarder"
default['splunk']['server_home']                  = "/opt/splunk"
default['splunk']['db_directory']                 = "/volr/splunk"

#web config
default['splunk']['web_server_port']              = "443"
default['splunk']['browser_timeout']              = "0"
default['splunk']['minify_js']                    = "true"
default['splunk']['minify_css']                   = "true"

default['splunk']['use_ssl']                      = false
default['splunk']['ssl_crt']                      = "ssl.crt"
default['splunk']['ssl_key']                      = "ssl.key"

# Dashboards to deploy
default['splunk']['deploy_dashboards']            = true
default['splunk']['dashboards_to_deploy']         = ["apache_http","useragents"]

# Static Server Configs (Configs that match regardless of environment -Dev,QA,PL,Prod,Etc)
default['splunk']['static_server_configs']        = ["web","transforms"]

# Dynamic Server Configs (Configs that change per environment)
default['splunk']['dynamic_server_configs']       = ["inputs","props"]

#configuration values for forwarders
default['splunk']['receiver_port']                = "9997"
default['splunk']['limits_thruput']               = "256"

#Change the default admin password (Username::Password)
default['splunk']['auth']                         = "admin:SomePassword123!!"

#Set the role of your splunk indexer
default['splunk']['server_role']                  = "splunk-server"
