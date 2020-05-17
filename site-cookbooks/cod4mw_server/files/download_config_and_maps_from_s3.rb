#!/usr/bin/env ruby
# frozen_string_literal: true

require 'aws-sdk-s3'

COD4_PATH = '/home/cod4server/serverfiles/main'

# TODO: des-harcodear
s3_client = Aws::S3::Client.new(credentials: Aws::InstanceProfileCredentials.new, region: 'sa-east-1')
bucket = Aws::S3::Bucket.new(name: 'peluchero', client: s3_client)

maps = bucket.objects(prefix: 'cod4mw/maps')
mods = bucket.objects(prefix: 'cod4mw/mods')
config = bucket.objects(prefix: 'cod4mw/config')
