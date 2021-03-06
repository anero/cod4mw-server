# frozen_string_literal: true

bash 'Add i386 architecture to dpkg' do
  code <<-CODE
  dpkg --add-architecture i386
  apt-get update
  CODE
  user 'root'
end

# Install LGSM dependencies
apt_package %w(mailutils postfix curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux netcat lib32gcc1 libstdc++6 libstdc++6:i386 libstdc++5:i386 lib32stdc++6)

# Create cod4server
user 'cod4server' do
  shell '/bin/bash'
  home '/home/cod4server'
  manage_home true
end

# Install dedicated server
bash 'Install LGSM' do
  code <<-CODE
  wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh cod4server
  CODE
  cwd '/home/cod4server'
  user 'cod4server'
end

bash 'Install CoD4MW server' do
  code <<-CODE
  ./cod4server auto-install
  CODE
  cwd '/home/cod4server'
  user 'cod4server'
end

# Copy overriden config for server
cookbook_file '/home/cod4server/lgsm/config-lgsm/cod4server/cod4server.cfg' do
  owner 'cod4server'
  group 'cod4server'
  source 'cod4server.cfg'
  mode '0644'
  action :create
end
