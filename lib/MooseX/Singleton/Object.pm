#!/usr/bin/env perl
package MooseX::Singleton::Object;
use Moose;
use metaclass 'MooseX::Singleton::Meta::Class';

extends 'Moose::Object';

no strict 'refs';

sub instance { shift->new }

1;

