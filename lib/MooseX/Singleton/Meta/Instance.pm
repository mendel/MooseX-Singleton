#!/usr/bin/env perl
package MooseX::Singleton::Meta::Instance;
use Moose;
use Scalar::Util 'weaken';

extends 'Moose::Meta::Instance';

sub get_singleton_instance {
    my ($self, $instance) = @_;

    return $instance if blessed $instance;

    # optimization: it's really slow to go through new_object for every access
    # so return the singleton if we see it already exists, which it will every
    # single except the first.
    no strict 'refs';
    return ${"$instance\::singleton"} if defined ${"$instance\::singleton"};

    return $instance->meta->construct_instance;
}

sub clone_instance {
    my ($self, $instance) = @_;
    $self->get_singleton_instance($instance);
}

sub get_slot_value {
    my ($self, $instance, $slot_name) = @_;
    $self->is_slot_initialized($instance, $slot_name) ? $self->get_singleton_instance($instance)->{$slot_name} : undef;
}

sub set_slot_value {
    my ($self, $instance, $slot_name, $value) = @_;
    $self->get_singleton_instance($instance)->{$slot_name} = $value;
}

sub deinitialize_slot {
    my ( $self, $instance, $slot_name ) = @_;
    delete $self->get_singleton_instance($instance)->{$slot_name};
}

sub is_slot_initialized {
    my ($self, $instance, $slot_name, $value) = @_;
    exists $self->get_singleton_instance($instance)->{$slot_name} ? 1 : 0;
}

sub weaken_slot_value {
    my ($self, $instance, $slot_name) = @_;
    weaken $self->get_singleton_instance($instance)->{$slot_name};
}

sub inline_slot_access {
    my ($self, $instance, $slot_name) = @_;
    sprintf "%s->meta->instance_metaclass->get_singleton_instance(%s)->{%s}", $instance, $instance, $slot_name;
}

no Moose;

1;

__END__

=pod

=head1 NAME

MooseX::Singleton::Meta::Instance

=head1 DESCRIPTION

This instance metaclass manages attribute access and storage. When accessing an
attribute, it will convert a bare package to its cached singleton instance
(creating it if necessary).

=cut

