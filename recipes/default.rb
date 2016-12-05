# Encoding: utf-8
#
# Cookbook Name:: kvexpress
# Recipe:: default
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

case node['platform_family']
when 'debian'

  package 'apt-transport-https'

  apt_repository 'kvexpress' do
    uri 'https://packagecloud.io/kvexpress/kvexpress/ubuntu'
    components ['main']
    distribution node['lsb']['codename']
    key 'https://packagecloud.io/gpg.key'
  end

  package 'kvexpress' do
    version node['kvexpress']['version']
    action :install
  end

when 'rhel'

  # there are no packages available for RHEL family, but fortunately
  # kvexpress is a single executable
  cache_filename = "#{Chef::Config[:file_cache_path]}/kvexpress-#{node['kvexpress']['version']}.gz"
  local_filename = '/usr/bin/kvexpress'

  execute 'install_kvexpress' do
    creates local_filename
    command <<-EOF
      gzip -cd #{cache_filename} > #{local_filename}
      chmod +x #{local_filename}
    EOF
    action :nothing
  end

  remote_file cache_filename do
    source node['kvexpress']['download_url']
    not_if { ::File.exist?(cache_filename) }
    notifies :run, 'execute[install_kvexpress]', :immediate
  end

end
