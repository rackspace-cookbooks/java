# Cookbook Name:: rackspace_java
# Recipe:: set_attributes_from_version
#
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

# Calculate variables that depend on jdk_version
# If you need to override this in an attribute file you must use
# force_default or higher precedence.

case node['platform_family']
when "rhel"
  case node['rackspace_java']['install_flavor']
  when "oracle"
    node.default['rackspace_java']['java_home'] = "/usr/lib/jvm/java"
  else
    node.default['rackspace_java']['java_home'] = "/usr/lib/jvm/java-1.#{node['rackspace_java']['jdk_version']}.0"
  end
  node.default['rackspace_java']['openjdk_packages'] = ["java-1.#{node['rackspace_java']['jdk_version']}.0-openjdk", "java-1.#{node['rackspace_java']['jdk_version']}.0-openjdk-devel"]
when "debian"
  node.default['rackspace_java']['java_home'] = "/usr/lib/jvm/java-#{node['rackspace_java']['jdk_version']}-#{node['rackspace_java']['install_flavor']}"
  # Newer Debian & Ubuntu adds the architecture to the path
  if node['platform'] == 'debian' && Chef::VersionConstraint.new(">= 7.0").include?(node['platform_version']) ||
     node['platform'] == 'ubuntu' && Chef::VersionConstraint.new(">= 12.04").include?(node['platform_version'])
    node.default['rackspace_java']['java_home'] = "#{node['rackspace_java']['java_home']}-#{node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'}"
  end
  node.default['rackspace_java']['openjdk_packages'] = ["openjdk-#{node['rackspace_java']['jdk_version']}-jdk", "openjdk-#{node['rackspace_java']['jdk_version']}-jre-headless"]
else
  node.default['rackspace_java']['java_home'] = "/usr/lib/jvm/default-java"
  node.default['rackspace_java']['openjdk_packages'] = ["openjdk-#{node['rackspace_java']['jdk_version']}-jdk"]
end
