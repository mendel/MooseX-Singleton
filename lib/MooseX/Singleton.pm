package MooseX::Singleton;
use Moose;
use MooseX::Singleton::Object;
use MooseX::Singleton::Meta::Class;

our $VERSION = 0.02;

sub import {
    my $caller = caller;

    Moose::init_meta($caller, 'MooseX::Singleton::Object', 'MooseX::Singleton::Meta::Class');

    Moose->import({into => $caller});
    strict->import;
    warnings->import;

}

1;

