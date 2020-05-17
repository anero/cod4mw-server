# frozen_string_literal: true

cookbook_file "download_config_and_maps_from_s3.rb" do
  source "download_config_and_maps_from_s3.rb"
  path "/usr/local/sbin/download_config_and_maps_from_s3.rb"
  group "root"
  owner "root"
  mode 0440
  action :create_if_missing
end

bash 'Install ruby dependencies' do
  code <<-CODE
  gem install aws-sdk-s3
  CODE
  user 'root'
end

bash 'Execute script to download maps and config from S3' do
  code <<-CODE

  CODE
  user 'root'
end
