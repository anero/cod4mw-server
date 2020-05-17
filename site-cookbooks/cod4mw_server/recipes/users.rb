# frozen_string_literal: true

cookbook_file '/tmp/human_users.json' do
  source 'human_users.json'
  action :nothing
end.run_action(:create)

human_users = JSON.parse(File.read('/tmp/human_users.json'))
human_users.each do |human_user|
  user human_user['name'] do
    shell '/bin/bash'
    manage_home true
  end

  directory "/home/#{human_user['name']}" do
    action :create
    mode '2755'
    owner human_user['name']
    group human_user['name']
  end

  group "sudo #{human_user['name']}" do
    action :modify
    group_name 'sudo'
    members human_user['name']
    append true
  end

  directory "/home/#{human_user['name']}/.ssh" do
    recursive true
    mode '700'
    owner human_user['name']
    group human_user['name']
  end

  # Authorize user to connect to server
  file "/home/#{human_user['name']}/.ssh/authorized_keys" do
    content human_user['key']
    mode '0600'
    owner human_user['name']
    group human_user['name']
  end
end

# Allow sudo command without password for sudoers
cookbook_file "sudo_without_password" do
  source "sudo_without_password"
  path "/etc/sudoers.d/sudo_without_password"
  group "root"
  owner "root"
  mode 0440
  action :create_if_missing
end
