# encoding: utf-8
#
# Cookbook Name:: kvexpress
# Attributes:: default
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

default['kvexpress']['version'] = '1.11-1'
default['datadog']['url'] = 'https://app.datadoghq.com'

# Where to place the JSON watches.
default['consul']['config_dir'] = '/etc/consul.d'

# If you're using Consul ACLs to protect the 'kvexpress/' KV space and kvexpress::server_config
# default['consul']['acl']['kvexpress'] = 'acl-goes-here'

# If you're using the Datadog API to send events and kvexpress::server_config
# default['datadog']['api_key'] = 'api_key_goes_here'
# default['datadog']['application_key'] = 'app_key_goes_here'

# If you're using the Datadog agent - change to true for metrics:
default['kvexpress']['dogstatsd'] = false
