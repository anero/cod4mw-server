# frozen_string_literal: true

# Start cod4server on init
cookbook_file '/lib/systemd/system/cod4server.service' do
  source 'cod4server.service'
  owner 'root'
  group 'root'
  action :create_if_missing
end

cookbook_file '/home/cod4server/serverfiles/main/cod4server.cfg' do
  owner 'cod4server'
  group 'cod4server'
  source 'game_config.cfg'
  mode '0504'
  action :create
end
