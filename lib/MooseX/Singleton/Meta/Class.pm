#!/usr/bin/env perl
package MooseX::Singleton::Meta::Class;
use Moose;
use MooseX::Singleton::Meta::Instance;

extends 'Moose::Meta::Class';

sub initialize {
    my $class = shift;
    my $pkg   = shift;

    $class->SUPER::initialize(
        $pkg,
        instance_metaclass => 'MooseX::Singleton::Meta::Instance',
        @_,
    );
};

1;

