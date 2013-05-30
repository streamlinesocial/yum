#
# Author:: Takeshi KOMIYA (<i.tkomiya@gmail.com>)
# Cookbook Name:: yum
# Recipe:: remi
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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

include_recipe "yum::epel"

yk = yum_key node['yum']['remi']['key'] do
  url  node['yum']['remi']['key_url']
  action :add
end

yr = yum_repository "remi" do
  description "Les RPM de remi pour Enterprise Linux #{node['platform_version']} - $basearch"
  key node['yum']['remi']['key']
  mirrorlist node['yum']['remi']['url']
  failovermethod "priority"
  includepkgs node['yum']['remi']['includepkgs']
  exclude node['yum']['remi']['exclude']
  action :create
end

# run durring compile time so the yum packages are available to other
# cookbooks that run durring compile time
if node['yum']['execute_at_compile_time']
    yk.run_action(:add)
    yr.run_action(platform?('amazon') ? [:add, :update] : :create)
end
