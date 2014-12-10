node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'rngd':
    require => Notify['enduser-before'],
    before  => Notify['enduser-after'],
  }

}
