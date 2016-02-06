#
# Cookbook Name:: chef_carminatiio
# Recipe:: setup
#
# Copyright 2015, carminati.io
#
# All rights reserved - Do Not Redistribute
#

## ----------
## Installs latest version of codedeploy
## ----------
remote_file "#{Chef::Config[:file_cache_path]}/codedeploy-install.sh" do
    source "https://s3.amazonaws.com/aws-codedeploy-us-east-1/latest/install"
    mode "0744"
    owner "root"
    group "root"
end

execute "install_codedeploy_agent" do
  command "#{Chef::Config[:file_cache_path]}/codedeploy-install.sh auto"
  user "root"
end

## ----------
## Create web app user
## ----------


## ----------
## Initializes app directory
## ----------
directory '/opt/carminatiio/' do
  owner 'root'
  group 'root'
  recursive true
end

## ----------
## Drop default nginx file from the box
## ----------
file '/etc/nginx/sites-enabled/default' do
  action :delete
end

## ----------
## Create symlink for nginx between sites-enabled and sites-available
## ----------


## ----------
## Create Nginx config file on the box
## ----------
# cookbook_file '/etc/nginx/sites-enabled/carminatiio' do
#   source 'carminatiio.conf'
#   action :create
# end


## ----------
## Drop supervisor config file
## ----------
