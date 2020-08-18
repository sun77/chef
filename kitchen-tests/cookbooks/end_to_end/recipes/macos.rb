#
# Cookbook:: end_to_end
# Recipe:: macos
#
# Copyright:: Copyright (c) Chef Software Inc.
#

chef_sleep "2"

execute "sleep 1"

execute "sleep 1 second" do
  command "sleep 1"
  live_stream true
end

execute "sensitive sleep" do
  command "sleep 1"
  sensitive true
end

timezone "America/Los_Angeles"

include_recipe "ntp"

include_recipe "resolver"

users_manage "remove sysadmin" do
  group_name "sysadmin"
  group_id 2300
  action [:remove]
end

users_manage "create sysadmin" do
  group_name "sysadmin"
  group_id 2300
  action [:create]
end

ssh_known_hosts_entry "github.com"

include_recipe "chef-client::delete_validation"
include_recipe "chef-client::config"

include_recipe "git"

# test various archive formats in the archive_file resource
%w{tourism.tar.gz tourism.tar.xz tourism.zip}.each do |archive|
  cookbook_file File.join(Chef::Config[:file_cache_path], archive) do
    source archive
  end

  archive_file archive do
    path File.join(Chef::Config[:file_cache_path], archive)
    extract_to File.join(Chef::Config[:file_cache_path], archive.tr(".", "_"))
  end
end

osx_profile "Remove screensaver profile" do
  identifier "com.company.screensaver"
  action :remove
end

build_essential

launchd "io.chef.testing.fake" do
  source "io.chef.testing.fake.plist"
  action "enable"
end

include_recipe "::_dmg_package"
include_recipe "::_macos_userdefaults"
include_recipe "::_ohai_hint"
include_recipe "::_openssl"
