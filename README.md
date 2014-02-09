#rackspace_java

Description
===========

This cookbook installs a Java JDK/JRE. It defaults to installing
OpenJDK, but it can also install Oracle. Default JDK version is 7

**IMPORTANT NOTE**

As of 26 March 2012 you can no longer directly download the JDK from
Oracle's website without using a special cookie. This cookbook uses
that cookie to download the oracle recipe on your behalf, however the
`rackspace_java::oracle` recipe forces you to set either override the
`node['rackspace_java']['oracle']['accept_oracle_download_terms']` to true or
set up a private repository accessible by HTTP.

### Example

override the `accept_oracle_download_terms` in, e.g., `roles/base.rb`

    default_attributes(
      :java => {
         :oracle => {
           "accept_oracle_download_terms" => true
         }
       }
    )

Requirements
============

Chef 0.10.10+ and Ohai 6.10+ for `platform_family` use.

## Platform

* Debian, Ubuntu
* CentOS/Red Hat 6+

Attributes
==========

See `attributes/default.rb` for default values.

* `node['rackspace_java']['install_flavor']` - Flavor of JVM you would like
installed (`oracle`, `openjdk`, `oracele_rpm` or `oracle_i586`), default `openjdk`.
* `node['rackspace_java']['jdk_version']` - JDK version to install, defaults to
  `'7'`.
* `node['rackspace_java']['java_home']` - Default location of the
  "`$JAVA_HOME`".
* `node['rackspace_java']['openjdk_packages']` - Array of OpenJDK package names
  to install in the `java::openjdk` recipe. This is set based on the
  platform.
* `node['rackspace_java']['jdk']` - Version and architecture specific attributes for setting the URL on Oracle's site for the JDK, and the checksum of the .tar.gz.
* `node['rackspace_java']['oracle']['accept_oracle_download_terms']` - Indicates that you accept Oracle's EULA

Recipes
=======

## default

Include the default recipe in a run list, to get `java`.  By default
the `openjdk` flavor of Java is installed, but this can be changed by
using the `install_flavor` attribute.

OpenJDK is the default because of licensing changes made upstream by
Oracle. See notes on the `oracle` recipe below.

NOTE: In most cases, including just the default recipe will be sufficient.
It's possible to include the install_type recipes directly, as long as
the necessary attributes (such as java_home) are set.

## set_attributes_from_version

Sets default attributes based on the JDK version. This logic must be in
a recipe instead of attributes/default.rb. See [#95](https://github.com/socrata-cookbooks/java/pull/95) for details.

## purge_packages

Purges deprecated Sun Java packages.

## openjdk

This recipe installs the `openjdk` flavor of Java. It also uses the
`alternatives` system on RHEL/Debian families to set the default Java.

## oracle

This recipe installs the `oracle` flavor of Java. This recipe does not
use distribution packages as Oracle changed the licensing terms with
JDK 1.6u27 and prohibited the practice for both RHEL and Debian family
platforms.

For both RHEL and Debian families, this recipe pulls the binary
distribution from the Oracle website, and installs it in the default
`JAVA_HOME` for each distribution. For Debian, this is
`/usr/lib/jvm/default-java`. For RHEl, this is `/usr/lib/jvm/java`.

After putting the binaries in place, the `java::oracle` recipe updates
`/usr/bin/java` to point to the installed JDK using the
`update-alternatives` script. This is all handled in the `java_ark`
LWRP.

## oracle_i386

This recipe installs the 32-bit Java virtual machine without setting
it as the default. This can be useful if you have applications on the
same machine that require different versions of the JVM.

This recipe operates in a similar manner to `java::oracle`.

## oracle_rpm

This recipe installs the Oracle JRE or JDK provided by a custom YUM
repositories.
It also uses the `alternatives` system on RHEL families to set
the default Java.

Resources/Providers
===================

## `rackspace_java_ark`

This cookbook contains the `java_ark` LWRP. Generally speaking this
LWRP is deprecated in favor of `ark` from the
[ark cookbook](https://github.com/opscode-cookbooks/ark), but it is
still used in this cookbook for handling the Oracle JDK installation.

By default, the extracted directory is extracted to
`app_root/extracted_dir_name` and symlinked to `app_root/default`

### Actions

- `:install`: extracts the tarball and makes necessary symlinks
- `:remove`: removes the tarball and run update-alternatives for all
  symlinked `bin_cmds`

### Attribute Parameters

- `url`: path to tarball, .tar.gz, .bin (oracle-specific), and .zip
  currently supported
- `checksum`: SHA256 checksum, not used for security but avoid
  redownloading the archive on each chef-client run
- `app_home`: the default for installations of this type of
  application, for example, `/usr/lib/tomcat/default`. If your
  application is not set to the default, it will be placed at the same
  level in the directory hierarchy but the directory name will be
   `app_root/extracted_directory_name + "_alt"`
- `app_home_mode`: file mode for app_home, is an integer
- `bin_cmds`: array of binary commands that should be symlinked to
  `/usr/bin`, examples are mvn, java, javac, etc. These cmds must be in
  the `bin` subdirectory of the extracted folder. Will be ignored if this
  `java_ark` is not the default
- `owner`: owner of extracted directory, set to "root" by default
- `default`: whether this the default installation of this package,
  boolean true or false

### Examples

    # install jdk6 from Oracle
    java_ark "jdk" do
        url 'http://download.oracle.com/otn-pub/java/jdk/6u29-b11/jdk-6u29-linux-x64.bin'
        checksum  'a8603fa62045ce2164b26f7c04859cd548ffe0e33bfc979d9fa73df42e3b3365'
        app_home '/usr/local/java/default'
        bin_cmds ["java", "javac"]
        action :install
    end

## `rackspace_java_alternatives`

The `rackspace_java_alternatives` LWRP uses `update-alternatives` command
to set and unset command alternatives for various Java tools
such as java, javac, etc.

### Actions

- `:set`: set alternatives for Java tools
- `:unset`: unset alternatives for Java tools

### Attribute Parameters

- `java_location`: Java installation location.
- `bin_cmds`: array of Java tool names to set or unset alternatives on.
- `default`: whether to set the Java tools as system default. Boolean, defaults to `true`.
- `priority`: priority of the alternatives. Integer, defaults to `1061`.

### Examples

    # set alternatives for java and javac commands
    rackspace_java_alternatives "set java alternatives" do
        java_location '/usr/local/java`
        bin_cmds ["java", "javac"]
        action :set
    end

###
Usage
=====

Simply include the `java` recipe where ever you would like Java installed.

To install Oracle flavored Java override the `node['rackspace_java']['install_flavor']` attribute with in role:

    name "java"
    description "Install Oracle Java on Ubuntu"
    default_attributes(
      "java" => {
        "install_flavor" => "oracle"
      }
    )
    run_list(
      "recipe[java]"
    )

CONTRIBUTING
============
Please see CONTRIBUTING guidelines [here](https://github.com/rackspace-cookbooks/contributing/blob/master/CONTRIBUTING.md)

TESTING
=======
Please see TESTING guidelines [here](https://github.com/rackspace-cookbooks/contributing/blob/master/CONTRIBUTING.md)

License and Author
==================

* Author: Seth Chisamore (<schisamo@opscode.com>)
* Author: Bryan W. Berry (<bryan.berry@gmail.com>)
* Author: Joshua Timberman (<joshua@opscode.com>)
* Author: Ryan Richard (<ryan.richard@rackspace.com>)

Copyright: 2008-2013, Opscode, Inc
Copyright: 2014, Rackspace, US Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
