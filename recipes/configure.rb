#
# Cookbook Name:: chef_carminatiio
# Recipe:: configure
#
# Copyright 2015, carminati.io
#
# All rights reserved - Do Not Redistribute
#

## ----------
## Starts codedeploy agent
## ----------
service "codedeploy-agent" do
  action [:enable, :start]
end

# ----------
# Installs Python packages via python-pip
# ----------
# node[:pip_python_packages].each_pair do |pkg, version|
#     execute "install-#{pkg}" do
#         command "pip install #{pkg}==#{version}"
#         not_if "[ `pip freeze | grep #{pkg} | cut -d'=' -f3` = '#{version}' ]"
#     end
# end

node[:pip_python_packages].each do |pkg|
    execute "install-#{pkg}" do
        command "pip install #{pkg}"
#        not_if "[ `pip freeze | grep #{pkg} | cut -d'=' -f3` = '#{version}' ]"
    end
end
