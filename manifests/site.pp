require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_10

  # default ruby versions
  ruby::version { '2.1.2': }

  # Install a php version and set as the global default php
  class { 'php::global':
    version => '5.5.9'
  }

  # Install Composer globally on your PATH
  include php::composer

  php::extension::mcrypt { 'mcrypt for 5.5.9':
    php => '5.5.9'
  }

  php::extension::memcached { 'memcached for 5.5.9':
    php => '5.5.9'
  }

  php::extension::xdebug { 'xdebug for 5.5.9':
    php => '5.5.9'
  }

  include mysql

  include firefox
  include firefox::aurora
  include firefox::nightly

  include chrome
  include chrome::beta
  include chrome::canary

  include skype

  include macvim

  include libreoffice

  include sequel_pro

  include postgresapp

  include iterm2::dev
  include iterm2::colors::solarized_light

  include pgadmin3

  include cloudapp

  include zsh

  include tmux

  include transmission

  include caffeine

  include dash

  include dropbox

  include charles

  include flux

  include gimp

  class { 'vagrant': }

  include vlc

  include keepassx

  include wkhtmltopdf

  include virtualbox

  include joinme

  include github_for_mac

  include android_file_transfer

  include heroku

  include fig

  include go

  include jq

  include atom

  inclue adobe_reader

  include memcached
  include memcached::lib

  include daisy_disk

  # common, useful packages
  package {
    [
      'coreutils',
      'curl',
      'gnu-sed',
      'readline',
      'ack',
      'findutils',
      'gnu-tar',
      'wget',
      'xz'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
