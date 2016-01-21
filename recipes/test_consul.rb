# Encoding: utf-8
#
# Cookbook Name:: kvexpress
# Recipe:: test_consul
#
# Copyright 2015, Datadog Inc.
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

directories = ['/etc/consul.d', '/var/lib/consul', '/var/log/consul']

directories.each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode 00755
    recursive true
    action :create
  end
end

package 'consul'

cookbook_file '/etc/init/consul.conf' do
  owner 'root'
  group 'root'
  mode 00644
end

cookbook_file '/etc/consul.d/default.json' do
  owner 'root'
  group 'root'
  mode 00644
end

link '/etc/init.d/consul' do
  to '/lib/init/upstart-job'
end

service 'consul' do
  supports status: true
  action [:enable, :start]
end
