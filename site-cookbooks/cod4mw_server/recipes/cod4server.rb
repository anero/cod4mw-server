# frozen_string_literal: true

cookbook_file '/home/cod4server/serverfiles/main/cod4server.cfg' do
  owner 'cod4server'
  group 'cod4server'
  source 'game_config.cfg'
  mode '0504'
  action :create
end

cookbook_file '/home/cod4server/serverfiles/main/weapons.cfg' do
  owner 'cod4server'
  group 'cod4server'
  source 'weapons.cfg'
  mode '0504'
  action :create
end

# Start cod4server on init
cookbook_file '/lib/systemd/system/cod4server.service' do
  source 'cod4server.service'
  owner 'root'
  group 'root'
  action :create_if_missing
end

bash 'enable cod4server' do
  code <<-CODE
  systemctl enable cod4server
  CODE

  user 'root'
  environment 'HOME' => '/root', 'USER' => 'root'
end

# HACK: For whatever reason first cod4server run is crashing, so as a workaround we run the server
# once so that next time we boot the image the systemd service starts correctly.
# This assumes cod4server will always crash on first run and thus it doesn't attempt to stop the server
# (attempting to stop a stopped server fails and makes the AMI build process to fail)
bash 'First CoD4MW server run' do
  code <<-CODE
  ./cod4server start
  sleep 30
  CODE
  cwd '/home/cod4server'
  user 'cod4server'
end
