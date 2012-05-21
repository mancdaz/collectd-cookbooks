#
# Cookbook Name:: collectd
# Recipe:: client
#
# Copyright 2010, Atari, Inc
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
#

include_recipe "collectd"

if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  # Lookup collectd master ip address
  collectd, something, arbitrary_value = Chef::Search::Query.new.search(:node, "roles:collectd-server AND chef_environment:#{node.chef_environment}")
  if collectd.length > 0
    Chef::Log.info("collectd::client using search")
    collectd_master_ip = collectd[0]['collectd']['master']['ip']
  else
    Chef::Log.info("nova::api-os-compute/keystone NOT using search")
    collectd_master_ip = node['collectd']['master']['ip']
  end
end

collectd_plugin "network" do
  options :server=>collectd_master_ip
end
