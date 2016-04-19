# Encoding: utf-8
#
# Cookbook Name:: kvexpress
# Recipe:: lwrp_test
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

#
# NOTE: THIS RECIPE IS NOT TO BE USED - IT'S ONLY FOR TESTING.
#

include_recipe 'kvexpress::default'
include_recipe 'kvexpress::test_consul'

bash 'load features.ini' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  kvexpress in -k features.ini -u http://git.io/v4gTF
  EOH
end

bash 'load compressed features.ini' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  kvexpress in -k features-compressed -z true -u http://git.io/v4gTF
  EOH
end

group 'dog' do
  action :create
end

user 'dog' do
  comment 'Dog User'
  uid '1000'
  gid 'dog'
  shell '/bin/bash'
end

directory '/etc/testing-kvexpress/' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

kvexpress 'features-compressed' do
  location '/etc/testing-kvexpress/features-compressed.ini'
  key 'features-compressed'
  compress true
  owner 'dog'
  mode '00644'
  command 'w'
  length 10
  notifies :reload, 'service[consul]', :delayed
end

kvexpress 'features' do
  location '/etc/testing-kvexpress/features-test.ini'
  key 'features.ini'
  owner 'dog'
  mode '00644'
  command 'w'
  length 100
  notifies :reload, 'service[consul]', :delayed
end

kvexpress 'testing' do
  location '/etc/testing-kvexpress/testing.ini'
  key 'features.ini'
  notifies :reload, 'service[consul]', :delayed
end

kvexpress 'another-one' do
  location '/etc/testing-kvexpress/another.ini'
  key 'features.ini'
  owner 'dog'
  mode '00750'
  command 'w'
  length 100
  notifies :reload, 'service[consul]', :delayed
end

kvexpress 'etc' do
  location '/etc/kvexpress-test.ini'
  key 'features.ini'
  command 'uptime'
  notifies :reload, 'service[consul]', :delayed
end

kvexpress 'quoting' do
  location '/etc/kvexpress-test-quoting.ini'
  key 'features.ini'
  command 'consul exec -service consul "sudo w"'
  notifies :reload, 'service[consul]', :delayed
end

# This should NOT overwrite the file from above since
# the key does NOT exist.
kvexpress 'failureone' do
  location '/etc/kvexpress-test-quoting.ini'
  key 'smeatures.ini'
  notifies :reload, 'service[consul]', :delayed
end

# This should NOT create a file
# the key does NOT exist.
kvexpress 'failuretwo' do
  location '/etc/should-never-exist.ini'
  key 'smeatures2.ini'
  notifies :reload, 'service[consul]', :delayed
end

bash 'stop consul' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  service consul stop
  sleep 5
  EOH
end

# NOTE: This file will be created AFTER Consul is restarted.
# But the LWRP will create the watch - which will run after
# Consul is restarted and will still create the file.
# kvexpress will not crash in this scenario now with 1.4+
# like it did with 1.3 and previous.
kvexpress 'failurethree' do
  location '/etc/consul-is-dead-but-i-am-still-here.ini'
  key 'features.ini'
end

bash 'wait 60 seconds' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  service consul start
  sleep 60
  EOH
end

directory '/etc/kvexpress/output/' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

kvexpress 'datalayer-raw-test' do
  location '/etc/kvexpress/output/datalayer.ini'
  key 'datalayer.ini'
  prefix "config/datadog/#{node.chef_environment}/consul_config"
  command 'kvexpress in -C /etc/datadog/kvexpress.yaml -k raw-datalayer.ini -f /etc/kvexpress/output/datalayer.ini'
  notifies :reload, 'service[consul]', :delayed
end

kvexpress 'features_canary' do
  location '/etc/tags.conf'
  key 'features.ini'
  kvexpress_group 'canary'
  notifies :reload, 'service[consul]', :delayed
end
