#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
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

#Supported options are "openjdk", "oracle", "oracele_rpm" or "oracle_i586"
default['rackspace_java']['install_flavor'] = "openjdk"

# default jdk attributes
default['rackspace_java']['jdk_version'] = '6'
default['rackspace_java']['arch'] = kernel['machine'] =~ /x86_64/ ? "x86_64" : "i586"
default['rackspace_java']['openjdk_packages'] = []
default['rackspace_java']['accept_license_agreement'] = false

case node['rackspace_java']['install_flavor']
when 'oracle_rpm'
  default['rackspace_java']['oracle_rpm']['type'] = 'jdk'
  default['rackspace_java']['java_home'] = "/usr/java/latest"
end

# if you change this to true, you can download directly from Oracle
default['rackspace_java']['oracle']['accept_oracle_download_terms'] = false

# jdk6 attributes
default['rackspace_java']['jdk']['6']['bin_cmds'] = [ "appletviewer", "apt", "ControlPanel", "extcheck", "HtmlConverter", "idlj", "jar", "jarsigner",
                                            "java", "javac", "javadoc", "javah", "javap", "javaws", "jconsole", "jcontrol", "jdb", "jhat",
                                            "jinfo", "jmap", "jps", "jrunscript", "jsadebugd", "jstack", "jstat", "jstatd", "jvisualvm",
                                            "keytool", "native2ascii", "orbd", "pack200", "policytool", "rmic", "rmid", "rmiregistry",
                                            "schemagen", "serialver", "servertool", "tnameserv", "unpack200", "wsgen", "wsimport", "xjc" ]
# jdk7 attributes
default['rackspace_java']['jdk']['7']['bin_cmds'] = [ "appletviewer", "apt", "ControlPanel", "extcheck", "idlj", "jar", "jarsigner", "java", "javac",
                                            "javadoc", "javafxpackager", "javah", "javap", "javaws", "jcmd", "jconsole", "jcontrol", "jdb",
                                            "jhat", "jinfo", "jmap", "jps", "jrunscript", "jsadebugd", "jstack", "jstat", "jstatd", "jvisualvm",
                                            "keytool", "native2ascii", "orbd", "pack200", "policytool", "rmic", "rmid", "rmiregistry",
                                            "schemagen", "serialver", "servertool", "tnameserv", "unpack200", "wsgen", "wsimport", "xjc" ]

# Oracle doesn't seem to publish SHA256 checksums for Java releases, so we use MD5 instead.
# Official checksums for the latest release can be found at http://www.oracle.com/technetwork/java/javase/downloads/java-se-binaries-checksum-1956892.html
# direct download paths for oracle, you have been warned!

# x86_64
default['rackspace_java']['jdk']['6']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin'
default['rackspace_java']['jdk']['6']['x86_64']['checksum'] = '6b493aeab16c940cae9e3d07ad2a5c5684fb49cf06c5d44c400c7993db0d12e8'

# i586
default['rackspace_java']['jdk']['6']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-i586.bin'
default['rackspace_java']['jdk']['6']['i586']['checksum'] = 'd53b5a2518d80e1d95565f0adda54eee229dc5f4a1d1a3c2f7bf5045b168a357'

# x86_64
default['rackspace_java']['jdk']['7']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz'
default['rackspace_java']['jdk']['7']['x86_64']['checksum'] = '764f96c4b078b80adaa5983e75470ff2'

# i586
default['rackspace_java']['jdk']['7']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-i586.tar.gz'
default['rackspace_java']['jdk']['7']['i586']['checksum'] = '909d353c1caf6b3b54cc20767a7778ef'
