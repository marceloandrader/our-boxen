class projects::coordinated_care {

  boxen::project { 'coordinated_care':
    mysql         => true,
    nginx         => true,
    php           => '5.6.3'
  }
}

