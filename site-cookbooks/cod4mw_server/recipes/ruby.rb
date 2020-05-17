# frozen_string_literal: true

# Prerequisite packages
apt_package %w(build-essential libssl-dev software-properties-common zlib1g-dev libreadline-dev libjemalloc-dev)

ruby_version = '2.5.3'
# Actually install ruby!
ruby_build_ruby ruby_version do
  environment(
    { 'CONFIGURE_OPTS' => '--with-jemalloc' }
  )
end

# This should match the version we just installed!
minor_ruby_version = '2.5.0'

ruby_bin_path = "/usr/local/ruby/#{ruby_version}/bin"
ruby_gems_path = "/usr/local/ruby/#{ruby_version}/lib/ruby/gems/#{minor_ruby_version}"

ENV['PATH'] = "#{ruby_bin_path}:#{ENV['PATH']}"
ENV['GEM_PATH'] = ruby_gems_path

template '/etc/environment' do
  source 'environment.erb'
  variables ruby_bin_path: ruby_bin_path, ruby_gems_path: ruby_gems_path
end

# TODO: Hace falta?
# link '/opt/rubies/current' do
#   to "/usr/local/ruby/#{ruby_version}"
#   link_type :symbolic
# end

# Many of our other AMI builders mess with permissions on gems that are installed globally.
# Instead of hardcoding the path where those gems are installed in all our cookbooks,
# stick it in the environment for root.
bash 'store GLOBAL_GEMS_PATH for use by downstream cookbooks' do
  code <<-CODE
  echo 'export GLOBAL_GEMS_PATH="#{ruby_gems_path}"' >> ~/.bash_profile
  CODE
  user 'root'
  environment 'HOME' => '/root', 'USER' => 'root'
end

bash "set up environment variables for root" do
  code <<-CODE
  echo 'export GEM_HOME="$HOME/.gem/ruby/#{ruby_version}"' >> ~/.bash_profile
  echo 'export GEM_PATH="$GEM_HOME:#{ruby_gems_path}"' >> ~/.bash_profile
  echo 'export PATH="$GEM_HOME/bin:#{ruby_bin_path}:$PATH"' >> ~/.bash_profile
  CODE
  user 'root'
  environment 'HOME' => '/root', 'USER' => 'root'
end

# This will install the latest stable version of bundler, since it is now packaged as part of rubygems.
execute 'gem update --system'

# nokigiri dependencies
apt_package 'patch'
