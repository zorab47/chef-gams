#
# Cookbook Name:: gams
# Recipe:: default
#
# Copyright 2014, ORM Technologies, LLC
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

gams_version       = node["gams"]["version"]       # => "24.2.1"
gams_install_path  = node["gams"]["install_path"]  # => "/opt/gams"
gams_symlink       = node["gams"]["symlink"]       # => "/usr/local/bin/gams"
gams_installer_url = node["gams"]["installer_url"] # => "http://.../linux_x64_64_sfx.exe"
gams_license       = node["gams"]["license"]

gams_minor_ver = gams_version.split(".").take(2).join(".") # => "24.2"
gams_platform  = ::File.basename gams_installer_url, ".*"            # => "linux_x64_64_sfx"
gams_path      = "#{gams_install_path}/gams#{gams_minor_ver}_#{gams_platform}"
gams_binary    = "#{gams_path}/gams"
gams_installer = "#{gams_path}/gamsinst"

src_filename = ::File.basename gams_installer_url
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"

if gams_license.nil?
  raise %q[GAMS license is required for installation. Ensure the node contains a valid license attribute: { "gams" => { "license" => "..." } }]
end

# Download installer, if required
remote_file src_filepath do
  source gams_installer_url
  mode 00744
  action :create_if_missing
  not_if { ::File.exist?(gams_binary) }
end

# Setup destination directory
directory gams_install_path do
  owner "root"
  group "root"
  mode 00755
  action :create
end

# Extract GAMS
execute src_filepath do
  cwd gams_install_path
  creates gams_binary
end

# Copy license into place
file "#{gams_path}/gamslice.txt" do
  action :create
  content node["gams"]["license"]
end

# Run installer to configure GAMS and setup the license
execute "gamsinst" do
  cwd gams_path
  command "./gamsinst -a" # install in non-interactive mode
end

# Symlink GAMS binary for global use
link gams_symlink do
  to gams_binary
end

# Remove installer when successful
file src_filepath do
  action :delete
  only_if { ::File.exist?(gams_binary) }
end
