Attributes
===========

apps
----
* `node['splunk']['unix_app_file']` - The name of the unix app file.  (files/default/apps)
* `node['splunk']['unix_app_version']` - The version number associated with this file.

* `node['splunk']['pdf_server_file']` - The name of the pdf server app file.  (files/default/apps)
* `node['splunk']['pdf_server_version']` - The version number associated with this file.

* `node['splunk']['deployment_mon_file']` - The name of the deployment monitor app file.  (files/default/apps)
* `node['splunk']['deployment_mon_version']` - The version number associated with this file.

* `node['splunk']['splunk_sos_file]` - The name of the Splunk on Splunk app file.  (files/default/apps)
* `node['splunk']['splunk_sos_version]` - The version number associated with this file.

* `node['splunk']['sideview_utils_file]` - The name of the sideview utils app file.  (files/default/apps)
* `node['splunk']['sideview_utils_version']` - The version number associated with this file.

* `node['splunk']['pulse_app_file']` - The name of the Pulse for AWS Cloudwatch app file.  (files/default/apps)
* `node['splunk']['pulse_app_version']` - The version number associated with this file.
* `node['splunk']['boto_remote_location]` - The base URL for downloading the Python boto library
* `node['splunk']['boto_verison]` - The version of boto to download
* `node['splunk']['dateutil_remote_location]` - The base URL for downloading the Python dateutil library
* `node['splunk']['dateutil_version]` - The version of python-dateutil to download

default
-------
* `node['splunk']['cookbook_name']` - The name of the directory in which the cookbook runs.

* `node['splunk']['indexer_name']` - The name to use for the forwarder outputs.conf defaultGroup. (templates/forwarder/outputs.conf.erb)
* `node['splunk']['forwarder_home']` - The directory in which to install the Splunk Forwarder
* `node['splunk']['server_home']` - The directory in which to install the Splunk Server
* `node['splunk']['db_directory']` - The directory to use for the Splunk Server Database. (templates/server/splunk-launch.conf.erb)

* `node['splunk']['web_server_port']` - The port number to assign the web server (httpport). (templates/server/web.conf.erb)
* `node['splunk']['browser_timeout']` - The inactivity timeout (ui_inactivity_timeout). (templates/server/web.conf.erb)
* `node['splunk']['minify_js']` - Indicates whether the static JS files for modules are consolidated and minified. (templates/server/web.conf.erb)
* `node['splunk']['minify_css']` - Indicates whether the static CSS files for modules are consolidated and minified. (templates/server/web.conf.erb)

* `node['splunk']['use_ssl']` - Toggles between http or https (enableSplunkWebSSL). (templates/server/web.conf.erb)
* `node['splunk']['ssl_crt']` - The cert file.  (files/default/ssl)
* `node['splunk']['ssl_key']` - The private key File.  (files/default/ssl)

* `node['splunk']['deploy_dashboards']` - Toggles deploying dashboards or not
* `node['splunk']['dashboards_to_deploy']` - An array of xml dashboards to copy over. These are the filenames minus the .xml suffix (files/default/dashboards)

* `node['splunk']['static_server_configs']` - An array of static server configs that *are not* specific to an environment (Dev, QA, PL, Prod, etc).  These are the primary names without the .conf.erb suffix. (templates/server)
* `node['splunk']['dynamic_server_configs']` - An array of dynamic server configs that *are* specific to an environment.  These are the primary names without the .conf.erb suffix.  (templates/server/#{node['splunk']['server_config_folder]})

* `node['splunk']['receiver_port']` - The default port in which to receive data from the forwarders.
* `node['splunk']['limits_thruput']` - The max amount of bandwidth, in KBps, the forwarders will use when sending data.  (templates/forawrder/limits.conf.erb)

* `node['splunk']['auth']` - The default admin password to use instead of splunks "changeme"

* `node['splunk']['server_role']` - The name of the splunk indexer.  Forwarders will search for this role in order to identify the server in which to send the data.

forwarder
---------
* `node['splunk']['forwarder_role']` - The name of the splunk forwarder role.  It is best to override this attribute per role.  This is the inputs file that will be moved over on the forwarding server.  (templates/forwarder/#{node['splunk']['forwarder_config_folder']}/#{node['splunk']['forwarder_role']}.inputs.conf.erb)
* `node['splunk']['forwarder_config_folder']` - The folder which contains the inputs file for the environment.  It is best to override this attribute per chef role. (templates/forwarder/#{node['splunk']['forwarder_config_folder]})
* `node['splunk']['server_config_folder']` - The folder which contains the environment specific server config files.  It is best to override this attribute per chef role.  (templates/server/#{node['splunk']['server_config_folder']})

versions
--------
* `node['splunk']['server_root']` - The base URL that splunk uses to download release files for Splunk Server
* `node['splunk']['server_version']` - The specific version of Splunk Server to download
* `node['splunk']['server_build]` - The specific build number of Splunk Server to download

* `node['splunk']['forwarder_root']` - The base URL that splunk uses to download release files for Splunk Forwarder
* `node['splunk']['forwarder_version']` - The specific version of Splunk Forwarder to download
* `node['splunk']['forwarder_build]` - The specific build number of Splunk Forwarder to download


License and Author
==================

Author:: Bryan Brandau (<bryan.brandau@bestbuy.com>)
Author:: Andrew Painter (<andrew.painter@bestbuy.com>)
Author:: Aaron Peterson (<aaron@opscode.com>)

Copyright 2011-2012, BBY Solutions, Inc.
Copyright 2011-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
