#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: yum
# Recipe:: epel
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# Copyright 2010, Eric G. Wolfe
# Copyright 2010, Tippr Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

yk = yum_key node['yum']['epel']['key'] do
  url  node['yum']['epel']['key_url']
  action :nothing
end

yr = yum_repository "epel" do
  description "Extra Packages for Enterprise Linux"
  key node['yum']['epel']['key']
  url node['yum']['epel']['baseurl']
  mirrorlist node['yum']['epel']['url']
  includepkgs node['yum']['epel']['includepkgs']
  exclude node['yum']['epel']['exclude']
  action platform?('amazon') ? :update : :nothing
end

# run durring compile time so the yum packages are available to other
# cookbooks that run durring compile time
if node['yum']['execute_at_compile_time']
    yk.run_action(:add)
    yr.run_action(platform?('amazon') ? [:add, :update] : :create)
end
