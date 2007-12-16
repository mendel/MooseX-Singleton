#!/usr/bin/env perl
package MooseX::Singleton::Meta::Instance;
use Moose;
use Scalar::Util 'weaken';

extends 'Moose::Meta::Instance';

sub instantiate {
    my ($self, $instance) = @_;

    return $instance if blessed $instance;
    return $instance->instance;
}

sub get_slot_value {
    my ($self, $instance, $slot_name) = @_;
    $self->is_slot_initialized($instance, $slot_name) ? $self->instantiate($instance)->{$slot_name} : undef;
}

sub set_slot_value {
    my ($self, $instance, $slot_name, $value) = @_;
    $self->instantiate($instance)->{$slot_name} = $value;
}

sub deinitialize_slot {
    my ( $self, $instance, $slot_name ) = @_;
    delete $self->instantiate($instance)->{$slot_name};
}

sub is_slot_initialized {
    my ($self, $instance, $slot_name, $value) = @_;
    exists $self->instantiate($instance)->{$slot_name} ? 1 : 0;
}

sub weaken_slot_value {
    my ($self, $instance, $slot_name) = @_;
    weaken $self->instantiate($instance)->{$slot_name};
}

sub inline_slot_access {
    my ($self, $instance, $slot_name) = @_;
    sprintf "%s->meta->instance_metaclass->instantiate(%s)->{%s}", $instance, $instance, $slot_name;
}

1;

