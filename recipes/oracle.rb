#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: rackspace_java
# Recipe:: oracle
#
# Copyright 2011, Bryan w. Berry
# Copyright 2014, Rackspace, US Inc.
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

unless node.recipe?('java::default')
  Chef::Log.warn('Using java::default instead is recommended.')

# Even if this recipe is included by itself, a safety check is nice...
  if node['rackspace_java']['java_home'].nil? || node['rackspace_java']['java_home'].empty?
    include_recipe 'rackspace_java::set_attributes_from_version'
  end
end

java_home = node['rackspace_java']['java_home']
arch = node['rackspace_java']['arch']
jdk_version = node['rackspace_java']['jdk_version'].to_s

# convert version number to a string if it isn't already
# if jdk_version.instance_of? Fixnum
#  jdk_version = jdk_version.to_s
# end

case jdk_version
when '6'
  tarball_url = node['rackspace_java']['jdk']['6'][arch]['url']
  tarball_checksum = node['rackspace_java']['jdk']['6'][arch]['checksum']
  bin_cmds = node['rackspace_java']['jdk']['6']['bin_cmds']
when '7'
  tarball_url = node['rackspace_java']['jdk']['7'][arch]['url']
  tarball_checksum = node['rackspace_java']['jdk']['7'][arch]['checksum']
  bin_cmds = node['rackspace_java']['jdk']['7']['bin_cmds']
end

if tarball_url =~ /example.com/
  Chef::Application.fatal!('You must change the download link to your private repository. You can no longer download java directly from http://download.oracle.com without broswer')
end

include_recipe 'rackspace_java::set_java_home'

rackspace_java_ark 'jdk' do
  url tarball_url
  checksum tarball_checksum
  app_home java_home
  bin_cmds bin_cmds
  alternatives_priority 1062
  action :install
end
