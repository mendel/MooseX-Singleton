#!/usr/bin/env perl
package MooseX::Singleton::Role::Object;
use Moose::Role;

sub instance { shift->new }

sub initialize {
  my ($class, @args) = @_;

  my $existing = $class->meta->existing_singleton;
  confess "Singleton is already initialized" if $existing;

  return $class->SUPER::new(@args);
}

override new => sub {
  my ($class, @args) = @_;

  my $existing = $class->meta->existing_singleton;
  confess "Singleton is already initialized" if $existing and @args;

  # Otherwise BUILD will be called repeatedly on the existing instance.
  # -- rjbs, 2008-02-03
  return $existing if $existing and ! @args;

  return super();
};

sub _clear_instance {
  my ($class) = @_;
  $class->meta->clear_singleton;
}

no Moose;

1;

__END__

=pod

=head1 NAME

MooseX::Singleton::Object - Object class role for MooseX::Singleton

=head1 DESCRIPTION

This just adds C<instance> as a shortcut for C<new>.

=cut

