Description
===========

This Chef cookbook provides recipes for installing Splunk Server, Splunk Forwarders, and a few sample Splunk Apps (DeploymentMonitor, PDF Server, *nix) in Amazon EC2.  It also includes a provider for installing other Splunk Apps.

Changes
=======

* v0.0.7 - To be filled in once all changes are complete.
* v0.0.4 - Added a splunk app: Pulse for AWS Cloudwatch.  This app will pull back metrics from AWS Cloudwatch and provides sample dashboards to display the information.  Read the SETUP.txt located in the root directory of the app file for installation requirements.
* v0.0.3 - Changing version of Splunk to 4.3
* v0.0.2 - Revamp
* v0.0.1 - Initial Release

Current Bugs
============

* The name of the app file, minus the .tar.gz, needs to be the same name as the directory in which it extracts.  If it is named incorrectly, the app install will fail.

Requirements
============

## Platform:

* Ubuntu, Debian, RedHat, CentOS, Fedora

- The cookbook is currently setup to run being named "splunk".  If you rename the cookbook from the original name of "splunk", be sure to modify the following:
	* attributes/default.rb: `node['splunk']['cookbook_name']`
	* recipes/*-app.rb: splunk_app_install -> {NEW_NAME}_app_install (e.g., splunk_app_install)
- This cookbook has only been tested thoroughly with Ubuntu

Attributes
==========

See attributes/README.md for values.

Recipes
=======

server
------

Installs Splunk Server

forwarder
---------

Installs Splunk Forwarder

deploy-mon-app
--------------

Installs the Deployment Monitor App
- Download the app from http://splunk-base.splunk.com/apps/22301/splunk-deployment-monitor and place it under files/default/apps/SplunkDeploymentMonitor.tar.gz

pdf-server-app
--------------

Installs the PDF Server App
- Download the app from http://splunk-base.splunk.com/apps/22348/pdf-report-server-install-on-linux-only and place it under files/default/apps/pdfserver.tar.gz

unix-app
--------

Installs the *nix App
- Download the app from http://splunk-base.splunk.com/apps/22314/splunk-for-unix-and-linux and place it under files/default/apps/unix.tar.gz

splunk-sos-app
--------------

Installs the Splunk on Splunk App and the required dependency app of Sideview Utils.  
- Download Splunk on Splunk from http://splunk-base.splunk.com/apps/29008/sos-splunk-on-splunk and place it under files/default/apps/sos.tar.gz
- Download Sideview Utils from http://splunk-base.splunk.com/apps/36405/sideview-utils and place it under files/default/apps/sideview_utils.tar.gz

pulse-app
---------

Installs the Pulse for AWS Cloudwatch App and the required Python libraries.

Usage
=====

## Forwarder Install:

This will install the Splunk Forwarder and shows an example of an attribute override to move a specific splunk inputs.conf file for this server.

	recipe[splunk::forwarder]

This will tell the forwarder to look for a splunk_chef_server.inputs.conf.erb file located in templates/default/forwarder/FORWARDER_CONFIG_FOLDER

	override_attributes(
		"splunk" => {
    		"forwarder_config_folder" => "prod",
    		"forwarder_role" => "splunk_chef_server"
		}
	)

## Server Install:

	recipe[splunk::server]
	
This will tell the splunk server to use the dynamic config files located in templates/default/server/SERVER_CONFIG_FOLDER
	
	override_attributes(
		"splunk" => {
			"server_config_folder" => "prod"
		}
	)

## Deployment Monitor App Install:

	recipe[splunk::deploy-mon-app]

Resources and Providers
=======================

`app_install.rb`

A default provider to install Splunk Apps.  This will install any required dependencies, install or upgrade the application, and move any local templates that are required.

Actions:

* `create_if_missing` - Creates and installs the app if the specific version number specified is not installed.

Attribute Parameters:

* `app_file` - The file that needs to be extracted and installed.  (required)
* `app_version` - The version of the app.  (required)
* `required_dependencies` - An array of required package dependencies.  (optional)
* `local_templates` - An array of local templates in .erb format to move over to the applications local config directory.  These files are stored in templates/apps/#{local_templates_directory}.
* `local_templates_directory` - The directory in which the local templates are stored.  (required if defining local_templates) - (templates/default/apps/NAME)
* `remove_dir_on_upgrade` - Remove the app directory before extracting the new app.  (required)

## Usage:

This will install or upgrade the *nix app:

	splunk_app_install "Installing #{node[:splunk][:unix_app_file]} -- Version: #{node[:splunk][:unix_app_version]}" do
		action                  [:create_if_missing]
		app_file                "#{node[:splunk][:unix_app_file]}"
		app_version             "#{node[:splunk][:unix_app_version]}"
		local_templates_directory "unix-app"
		local_templates         ["app.conf.erb","inputs.conf.erb"]
		remove_dir_on_upgrade   "true"
	end

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