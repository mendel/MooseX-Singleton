#!/usr/bin/env perl
package MooseX::Singleton::Object;
use Moose;
use metaclass 'MooseX::Singleton::Meta::Class';

extends 'Moose::Object';

sub instance { shift->new }

1;

__END__

=pod

=head1 NAME

MooseX::Singleton::Object - base class for MooseX::Singleton

=head1 DESCRIPTION

This just adds C<instance> as a shortcut for C<new>.

=cut

