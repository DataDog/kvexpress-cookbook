# Encoding: utf-8
#
# Cookbook Name:: kvexpress
# Resource:: kvexpress
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

require 'json'

actions :create, :delete
default_action :create

attribute :name, name_attribute: true, required: true, kind_of: String
attribute :location, required: true, kind_of: String
attribute :key, required: true, kind_of: String
attribute :length, required: false, default: 10, kind_of: Integer
attribute :owner, required: false, kind_of: String
attribute :kvexpress_group, required: false, kind_of: String
attribute :prefix, required: false, kind_of: String
attribute :mode, required: false, default: '00640', kind_of: String
attribute :command, required: false, kind_of: String

def path
  ::File.join(node['consul']['config_dir'], "key-watch-#{name}.json")
end

def key_path
  actual_path = "/kvexpress/#{key}/checksum"
  actual_path = "/#{prefix}/#{key}" unless prefix.to_s.empty?
  unless kvexpress_group.to_s.empty?
    group_match = check_kvexpress_group(kvexpress_group.to_s)
    actual_path = "/kvexpress/#{kvexpress_group}/#{key}/checksum" if group_match
  end
  actual_path
end

def check_kvexpress_group(possible_group)
  tag_string = "kvexpress:#{possible_group}"
  if node.tags.include?(tag_string)
    return true
  else
    return false
  end
end

def handler_key
  actual_key = key
  unless kvexpress_group.to_s.empty?
    group_match = check_kvexpress_group(kvexpress_group.to_s)
    actual_key = "#{kvexpress_group}/#{key}" if group_match
  end
  actual_key
end

def handler # rubocop:disable Metrics/AbcSize
  kvexpress_command = 'out'
  kvexpress_command = 'raw' unless prefix.to_s.empty?
  handler_command = "kvexpress #{kvexpress_command} -k #{handler_key} -f #{location} -l #{length} -c #{mode}"
  handler_command += ' -d true' if node['kvexpress']['dogstatsd']
  handler_command += " -o #{owner}" unless owner.to_s.empty?
  handler_command += " -p '#{prefix}'" unless prefix.to_s.empty?
  handler_command += " -e '#{command}'" unless command.to_s.empty?
  handler_command
end

def to_json
  JSON.pretty_generate(to_hash)
end

def to_hash
  hash = {
    watches: [
      {
        type: 'key',
        key: key_path,
        handler: handler
      }
    ]
  }
  hash
end
