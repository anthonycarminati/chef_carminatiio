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
## TODO: Create web app user
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
## Delete default nginx file from the box
## ----------
file '/etc/nginx/sites-enabled/default' do
  action :delete
end


## ----------
## Create symlink for nginx between sites-enabled and sites-available
## ----------
link '/etc/nginx/sites-available/carminatiio' do
  to '/etc/ntinx/sites-enabled/carminatiio'
end

## ----------
## Create nginx config file on the box
## ----------
cookbook_file '/etc/nginx/sites-enabled/carminatiio' do
  source 'carminatiio'
  action :create
end


## ----------
## Create supervisor config file on the box
## ----------
# cookbook_file '/etc/supervisor/conf.d/carminatiio.conf' do
#   source 'carminatiio.conf'
#   action :create
# end
template "/etc/supervisor/conf.d/carminatiiio.conf" do #node[:service_config][:supervisor_config] do
  source 'supervisor.erb'
  owner 'root'
  group 'root'
  variables({
      :MAIL_SERVER => node[:app_config][:env_var][:MAIL_SERVER],
      :MAIL_PORT => node[:app_config][:env_var][:MAIL_PORT],
      :MAIL_USERNAME => node[:app_config][:env_var][:MAIL_USERNAME],
      :MAIL_PASSWORD => node[:app_config][:env_var][:MAIL_PASSWORD],
      :MAIL_USE_SSL => node[:app_config][:env_var][:MAIL_USE_SSL],
      :MAIL_USE_TLS => node[:app_config][:env_var][:MAIL_USE_TLS],
      :SQLALCHEMY_DATABASE_URI => node[:app_config][:env_var][:SQLALCHEMY_DATABASE_URI],
      :FLASK_CONFIG => node[:app_config][:env_var][:FLASK_CONFIG]
            })
end