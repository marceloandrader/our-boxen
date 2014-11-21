class projects::coordinated_care {

  php::project { 'coordinated_care':
    mysql         => true,
    nginx         => true,
    php           => '5.5.9',
    source        => 'WordPress/WordPress'
  }
}

