#!/usr/bin/env perl
package MooseX::Singleton::Object;
use Moose;

extends 'Moose::Object';

sub instance { shift->new }

sub initialize {
  my ($class, @args) = @_;

  my $existing = $class->meta->existing_singleton;
  confess "Singleton is already initialized" if $existing;

  return $class->SUPER::new(@args);
}

sub new {
  my ($class, @args) = @_;

  my $existing = $class->meta->existing_singleton;
  confess "Singleton is already initialized" if $existing and @args;

  # Otherwise BUILD will be called repeatedly on the existing instance.
  # -- rjbs, 2008-02-03
  return $existing if $existing and ! @args;

  return $class->SUPER::new(@args);
}

no Moose;

1;

__END__

=pod

=head1 NAME

MooseX::Singleton::Object - base class for MooseX::Singleton

=head1 DESCRIPTION

This just adds C<instance> as a shortcut for C<new>.

=cut

