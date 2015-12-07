#
# Cookbook Name:: chef_carminatiio
# Recipe:: default
#
# Copyright 2015, carminati.io
#
# All rights reserved - Do Not Redistribute
#

## ----------
## Installs latest version of codedeploy and starts agent
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

service "codedeploy-agent" do
  action [:enable, :start]
end

## ----------
## Initializes app directory
## ----------
directory '/opt/carminatiio/' do
  owner 'root'
  group 'root'
  recursive true
end

## ----------
## Installs Python packages via python-pip
## ----------
node[:pip_python_packages].each_pair do |pkg, version|
    execute "install-#{pkg}" do
        command "pip install #{pkg}==#{version}"
        not_if "[ `pip freeze | grep #{pkg} | cut -d'=' -f3` = '#{version}' ]"
    end
end

node[:pip_python_packages].each do |pkg|
    execute "install-#{pkg}" do
        command "pip install #{pkg}"
#        not_if "[ `pip freeze | grep #{pkg} | cut -d'=' -f3` = '#{version}' ]"
    end
end
