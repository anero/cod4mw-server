# frozen_string_literal: true

cookbook_file '/home/cod4server/serverfiles/main/cod4server.cfg' do
  owner 'cod4server'
  group 'cod4server'
  source 'game_config.cfg'
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
