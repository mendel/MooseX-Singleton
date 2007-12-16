#!/usr/bin/env perl
package MooseX::Singleton::Object;
use Moose;
use metaclass 'MooseX::Singleton::Meta::Class';

extends 'Moose::Object';

no strict 'refs';

override new => sub {
    my $class = shift;

    # create exactly one instance
    if (!defined ${"$class\::singleton"}) {
        ${"$class\::singleton"} = super;
    }

    return ${"$class\::singleton"};
};

sub instance { shift->new }

1;

