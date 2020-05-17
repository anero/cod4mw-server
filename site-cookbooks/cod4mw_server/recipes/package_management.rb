# frozen_string_literal: true

# Update info on packages
apt_update 'update package info' do
  action :update
end

# Update the keyring
execute 'apt-key update' do
  ignore_failure true
  timeout 60
end

# Update all packages, non-interactively. All of these flags are to ensure it is completely non-interactive.
execute 'DEBIAN_FRONTEND=noninteractive apt-get -fuy -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade'

apt_package 'git'

ssh_known_hosts_entry 'github.com'

# Don't automatically update packages during normal operation.
apt_package 'cron-apt' do
  action :remove
end