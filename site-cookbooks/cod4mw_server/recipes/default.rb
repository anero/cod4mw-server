# frozen_string_literal: true

include_recipe 'cod4mw_server::package_management'
include_recipe 'cod4mw_server::users'
include_recipe 'ruby_build'
include_recipe 'cod4mw_server::ruby'
include_recipe 'cod4mw_server::linux_gsm'
include_recipe 'cod4mw_server::download_config_and_maps'
