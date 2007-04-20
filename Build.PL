#!/usr/bin/env perl

use Module::Build;

use strict;
use warnings;

Module::Build->new (
  module_name => 'MooseX::Singleton',
  license => 'perl',
  requires => {
    'Moose' => '0.20',
  },
  build_requires => {
    'Test::More' => '0.70',
    'Test::Exception' => '0.25',
  },
)->create_build_script;

